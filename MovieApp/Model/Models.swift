//
//  Movie
//  MovieApp
//
//  Created by Melissa Zellhuber on 12/4/18.
//  Copyright © 2018 mzellhuber. All rights reserved.
//

import Foundation

struct Results : Codable {
    let page : Int?
    let total_results : Int
    let total_pages : Int
    let results : [Movie]?
}

struct Movie : Codable {
    let vote_count : Int?
    let id : Int
    let video : Bool?
    let vote_average : Double
    let title : String
    let popularity : Double?
    let poster_path : String?
    let original_language : String?
    let original_title : String?
    let genre_ids : [Int]
    let backdrop_path : String?
    let adult : Bool?
    let overview : String?
    let release_date : String?
}

struct VideoResults : Codable {
    let id : Int?
    let results : [Video]
}

struct Video : Codable {
    let id : String
    let iso_639_1 : String?
    let iso_3166_1 : String?
    let key : String
    let name : String
    let site : String?
    let size : Int?
    let type : String?
}
