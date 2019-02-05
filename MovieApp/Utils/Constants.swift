//
//  Constants.swift
//  MovieApp
//
//  Created by Melissa Zellhuber on 2/1/19.
//  Copyright © 2018 mzellhuber. All rights reserved.
//

import Foundation

struct Genres{
    static public let genreNames = [28:"Action",12:"Adventure",16:"Animation",35:"Comedy",80:"Crime",99:"Documentary",18:"Drama",10751:"Family",14:"Fantasy",36:"History",27:"Horror",10402:"Music",9648:"Mystery",10749:"Romance",878:"Science Fiction",10770:"TV Movie",53:"Thriller",10752:"War",37:"Western"]
}

struct API {
    static public var key : String{
        get {
            var keys: NSDictionary?
            
            if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
                keys = NSDictionary(contentsOfFile: path)
                
                if let dict = keys {
                    if let key =  dict["MoviedbAPIKey"] as? String{
                        return key
                    }
                }
            }
            return ""
        }
    }
    
    static public let baseURL = "https://api.themoviedb.org/3/"
}

enum MovieURLPaths: String {
    case popular = "movie/popular"
    case top_rated = "movie/top_rated"
    case upcoming = "movie/upcoming"
    case detail = "movie/"
    case search = "search/movie"
    case image_path = "http://image.tmdb.org/t/p/w300/"
    case website = "https://www.themoviedb.org/movie/"
}
