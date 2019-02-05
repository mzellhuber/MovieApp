//
//  Networking.swift
//  MovieApp
//
//  Created by Melissa Zellhuber on 2/1/19.
//  Copyright © 2018 mzellhuber. All rights reserved.
//

import UIKit

class Networking: NSObject {
    
    static let shared = Networking()

    func getMovies(method:String, query:String = "", completion: @escaping ([Movie]?, Results?, Error?) -> ()) {
        
        if Reachability.isConnectedToNetwork(){
            var fullURL = "\(API.baseURL)\(method)&api_key=\(API.key)"
            if query != "" {
                fullURL = "\(fullURL)&query=\(query)"
            }
            
            //print(fullURL)
            guard let url = URL(string: fullURL) else { return }
            URLSession.shared.dataTask(with: url) { (data, resp, err) in
                if let err = err {
                    completion(nil, nil, err)
                    print("Failed to fetch movies:", err)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let results = try JSONDecoder().decode(Results.self, from: data)
                    DispatchQueue.main.async {
                        if let movies = results.results {
                            //print(movies)
                            MovieCache.shared.saveListInCache(key: method, movies: movies)
                        }
                        completion(results.results, results, nil)
                    }
                } catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
                }.resume()
        }else{
            //print("No internet")
            MovieCache.shared.getListFromCache(key: method) { (movies) in
                
                if movies == nil {
                    completion([], nil, nil)
                }
                completion(movies, nil, nil)
            }
        }
        
    }
    
    func getMovieVideoPath(id:Int, completion: @escaping ([Video]?, Error?) -> ()){
        if Reachability.isConnectedToNetwork(){
            //Download info from network
            
            let videoURL = "\(API.baseURL)\(MovieURLPaths.detail.rawValue)\(id)/videos?api_key=\(API.key)"
                        
            guard let url = URL(string: videoURL) else { return }
            URLSession.shared.dataTask(with: url) { (data, resp, err) in
                if let err = err {
                    completion(nil, err)
                    print("Failed to fetch movie video:", err)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let results = try JSONDecoder().decode(VideoResults.self, from: data)
                    DispatchQueue.main.async {
                        //No need to cache since we need internet to watch the videos
                        completion(results.results, nil)
                    }
                } catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
                }.resume()
            
        }else{
            //print("No internet")
        }
    }
}
