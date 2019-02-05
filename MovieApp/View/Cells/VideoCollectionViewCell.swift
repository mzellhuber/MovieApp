//
//  VideoCollectionViewCell.swift
//  MovieApp
//
//  Created by Melissa Zellhuber on 2/1/19.
//  Copyright © 2019 mzellhuber. All rights reserved.
//

import UIKit
import WebKit

class VideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var videoWebView: WKWebView!
    
    @IBOutlet weak var videoTitleLbl: UILabel!
    
    let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height:40))
    
    var videoViewModel: VideoViewModel! {
        didSet {
            videoTitleLbl.text = videoViewModel.name
            videoWebView.navigationDelegate = self
            if let url = URL(string: videoViewModel.url){
                videoWebView.load(URLRequest(url: url))
            }
            videoWebView.isHidden = true
            addActivityIndicator(view: self)
        }
    }
    
    func addActivityIndicator(view: UIView) {
        spinner.clipsToBounds = true
        spinner.hidesWhenStopped = true
        spinner.style = UIActivityIndicatorView.Style.white;
        spinner.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2.28)        
        view.addSubview(spinner)
        spinner.startAnimating()
    }
}

extension VideoCollectionViewCell : WKNavigationDelegate{
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        videoWebView.isHidden = false
        spinner.removeFromSuperview()
    }
}
