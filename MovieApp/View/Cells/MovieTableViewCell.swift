//
//  MovieTableViewCell.swift
//  MovieApp
//
//  Created by Melissa Zellhuber on 2/1/19.
//  Copyright © 2018 mzellhuber. All rights reserved.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {
        
    @IBOutlet weak var posterImgView: UIImageView!
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    
    var movieViewModel: MovieViewModel! {
        didSet {
            movieTitleLbl.text = movieViewModel.title
            genreLbl.text = movieViewModel.genre
            ratingLbl.text = movieViewModel.rating
            posterImgView.sd_setImage(with: URL(string: movieViewModel.backdrop))
        }
    }
}
