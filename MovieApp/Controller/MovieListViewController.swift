//
//  ViewController.swift
//  MovieApp
//
//  Created by Melissa Zellhuber on 2/1/19.
//  Copyright © 2018 mzellhuber. All rights reserved.
//

import UIKit
import TwicketSegmentedControl
import TBEmptyDataSet
import MBProgressHUD
import ViewAnimator

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuToolbar: UIToolbar!
    
    var movieViewModels = [MovieViewModel]()
    private var selectedMovie : MovieViewModel?
    let searchController = UISearchController(searchResultsController: nil)
    
    var segmentedControl:TwicketSegmentedControl!
    var page = 1
    var queryText = ""
    var listType = MovieURLPaths.popular.rawValue
    
    var totalPages = 0
    var totalResults = 0
    
    private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "cellId")

        setUpSegmented()
        setUpSearchBar()
        setUpEmptyDataSet()
        checkConnectivity()
        
        getMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    
    func setUpSegmented() {
        let titles = ["Popular", "Top Rated", "Upcoming"]
        let frame = CGRect(x: 0, y: 0, width: view.frame.width - 10, height: 40)
        
        segmentedControl = TwicketSegmentedControl(frame: frame)
        
        segmentedControl.setSegmentItems(titles)
        segmentedControl.delegate = self
        segmentedControl.backgroundColor = UIColor(red: 58/255, green: 189/255, blue: 255/255, alpha: 1.0)
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        menuToolbar.addSubview(segmentedControl)
    }
    
    func setUpSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        for textField in searchController.searchBar.subviews.first!.subviews where textField is UITextField {
            textField.subviews.first?.backgroundColor = .white
            textField.subviews.first?.layer.cornerRadius = 10.5
            textField.subviews.first?.layer.masksToBounds = true
        }
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = .white

    }
    
    func setUpEmptyDataSet(){
        self.tableView?.emptyDataSetDataSource = self
        self.tableView?.emptyDataSetDelegate = self
        self.tableView.separatorColor = .clear
    }
    
    func checkConnectivity(){
        if !Reachability.isConnectedToNetwork(){
            Toast.show(message: "No internet connection", controller: self)
        }
    }
    
    fileprivate func getMovies(query:String = "") {
        DispatchQueue.main.async {
            self.checkConnectivity()
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }

        let method = "\(listType)?page=\(page)"
        Networking.shared.getMovies(method: method, query: query) { (movies, result, error) in
            if let error = error {
                print("Failed to fetch movies:", error)
                //display error
                return
            }
            //print(movies)
            
            let moviesAPI = movies?.map({return MovieViewModel(movie: $0)}) ?? []
            if let pages = result?.total_pages{
                self.totalPages = pages
            }
            if let totalRes = result?.total_results{
                self.totalResults = totalRes
            }
            
            self.movieViewModels = self.movieViewModels + moviesAPI
            DispatchQueue.main.async {
                //View update must always happen in main thread
                
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                
                if self.page == 1{
                    self.tableView.scroll(animated: true)
                    self.animateCells()
                }else{
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    func animateCells() {
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50), execute: {
            UIView.animate(views: self.tableView.visibleCells, animations: self.animations, completion: nil)
        })
        
    }

}

extension MovieListViewController: TwicketSegmentedControlDelegate {
    func didSelect(_ segmentIndex: Int) {
        page = 1
        self.movieViewModels = []
        selectListType(segmentIndex: segmentIndex)
        queryText = ""
        getMovies()
    }
    
    func selectListType(segmentIndex:Int) {
        switch segmentIndex{
        case 0:
            listType = MovieURLPaths.popular.rawValue
            break
        case 1:
            listType = MovieURLPaths.top_rated.rawValue
            break
        case 2:
            listType = MovieURLPaths.upcoming.rawValue
            break
        default:
            listType = MovieURLPaths.popular.rawValue
            break
        }
    }
}

extension MovieListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MovieTableViewCell
        cell.selectionStyle = .none

        let movieViewModel = movieViewModels[indexPath.row]
        
        cell.movieViewModel = movieViewModel
        
        if indexPath.row == self.movieViewModels.count - 1 && page <= self.totalPages && movieViewModels.count <= self.totalResults{
            page = page + 1
            getMovies(query: queryText)
        }
        
        return cell
    }
}

extension MovieListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Segue to detail page
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailViewController
        let movie = movieViewModels[indexPath.row]
        
        detailVC.movieDetailViewModel = movie
        

        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if Reachability.isConnectedToNetwork() {
            if let text = searchBar.text {
                
                movieViewModels = []
                listType = "\(MovieURLPaths.search.rawValue)"
                page = 1
                if let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed){
                    getMovies(query:encodedText)
                    queryText = encodedText
                }else{
                    getMovies(query:text)
                    queryText = text
                }
            }
        }else{
            Toast.show(message: "No internet connection", controller: self)
        }
        
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if movieViewModels.isEmpty {
            segmentedControl.move(to: 0)
            listType = MovieURLPaths.popular.rawValue
            queryText = ""
            getMovies()
        }
    }
}

extension MovieListViewController : TBEmptyDataSetDelegate, TBEmptyDataSetDataSource {
    func imageForEmptyDataSet(in scrollView: UIScrollView) -> UIImage? {
        return #imageLiteral(resourceName: "sad")
    }
    
    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        let attributes = [.font : UIFont.systemFont(ofSize: 22),
                          .foregroundColor: UIColor.gray] as [NSAttributedString.Key: Any]?
        
        return NSAttributedString(string: "There are no results for this", attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        let attributes = [.font: UIFont.systemFont(ofSize: 17),
                          .foregroundColor: UIColor.gray] as [NSAttributedString.Key: Any]?
        return NSAttributedString(string: "Please try another search", attributes: attributes)
    }
    
    func emptyDataSetShouldDisplay(in scrollView: UIScrollView) -> Bool {
        return movieViewModels.count == 0
    }
}
