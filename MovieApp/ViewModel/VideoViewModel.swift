//
//  VideoViewModel.swift
//  MovieApp
//
//  Created by Melissa Zellhuber on 2/1/19.
//  Copyright © 2019 mzellhuber. All rights reserved.
//
import UIKit

class VideoViewModel {
    
    let id : String
    var url : String
    let name : String
    let site : String
    
    init(video: Video) {
        self.id = video.id
        self.name = video.name
        self.url = ""
        if let site = video.site{
            self.site = site
            if self.site == "YouTube"{
                self.url = "https://www.youtube.com/embed/\(video.key)"
            }
        }else{
            self.site = ""
        }
    }
}
