//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Melissa Zellhuber on 2/1/19.
//  Copyright © 2019 mzellhuber. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var moviePosterImgView: UIImageView!
    @IBOutlet weak var genresLbl: UILabel!
    @IBOutlet weak var releaseDateLbl: UILabel!
    @IBOutlet weak var overviewTxtView: UITextView!
    @IBOutlet weak var backgroundImgView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!

     var movieDetailViewModel: MovieViewModel!
    
    var videoViewModels = [VideoViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfo()
        blurImage()
        
        self.navigationController?.navigationBar.tintColor = .white
        
        collectionView.register(UINib(nibName: "VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "videoCell")

        //No need to share or load videos if there is no internet
        if Reachability.isConnectedToNetwork(){
            setBarButtonItem()
            getMovieVideos()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setBarButtonItem() {
        
        let shareBar: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem:.action, target: self, action: #selector(self.share))
        
        self.navigationItem.rightBarButtonItem = shareBar
    }
    
    func setInfo() {
        genresLbl.text = movieDetailViewModel.genre
        moviePosterImgView.sd_setImage(with: URL(string: movieDetailViewModel.poster), placeholderImage: UIImage(named: "noImage"))
        releaseDateLbl.text = movieDetailViewModel.release_date
        overviewTxtView.text = movieDetailViewModel.overview
        backgroundImgView.sd_setImage(with: URL(string: movieDetailViewModel.backdrop))

        self.navigationItem.title = movieDetailViewModel.title
    }
    
    //Set a blurred background of the backdrop photo
    func blurImage() {
        let blurView = UIVisualEffectView()
        blurView.frame = backgroundImgView.frame
        blurView.effect = UIBlurEffect(style: .light)
        backgroundImgView.addSubview(blurView)
    }
    
    func getMovieVideos() {
        Networking.shared.getMovieVideoPath(id: movieDetailViewModel.id) { (videos, error) in
            //print(videos)
            self.videoViewModels = videos?.map({return VideoViewModel(video: $0)}) ?? []

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }
    
    @objc func share() {
        let text = movieDetailViewModel.title
        let movieID = String(movieDetailViewModel.id)
        if let url = URL(string: MovieURLPaths.website.rawValue + movieID) {
            let shareAll = [text , url] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}

extension MovieDetailViewController : UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! VideoCollectionViewCell
        
        cell.videoViewModel = videoViewModels[indexPath.row]
        
        return cell
    }
}
