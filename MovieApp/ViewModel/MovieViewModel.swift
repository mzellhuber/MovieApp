//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Melissa Zellhuber on 2/1/19.
//  Copyright © 2018 mzellhuber. All rights reserved.
//
import UIKit

class MovieViewModel {
    
    let id: Int
    let title: String
    let genre: String
    let rating: String
    let backdrop: String
    let overview: String
    let poster: String
    let release_date: String
    
    init(movie: Movie) {
        self.id = movie.id
        
        self.title = movie.title
        
        self.genre = (Genres.genreNames.filter { movie.genre_ids.contains($0.key)}).map{"\($0.value)"}.joined(separator: ", ")
        
        self.rating = "Rating \(Int(movie.vote_average * 10))%"
        
        if let backdrop = movie.backdrop_path{
            self.backdrop = MovieURLPaths.image_path.rawValue + backdrop
        }else{
            self.backdrop = ""
        }
        
        if let overview = movie.overview{
            self.overview = overview
        }else{
            self.overview = ""
        }
        
        if let poster = movie.poster_path{
            self.poster = MovieURLPaths.image_path.rawValue + poster
        }else{
            self.poster = ""
        }
        
        if let release_date = movie.release_date{
            self.release_date = "Released: \(release_date.formatDate())"
        }else{
            self.release_date = "Released: -"
        }
    }
}
