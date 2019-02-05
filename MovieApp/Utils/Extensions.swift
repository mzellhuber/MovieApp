//
//  Extensions.swift
//  MovieApp
//
//  Created by Melissa Zellhuber on 2/1/19.
//  Copyright © 2019 mzellhuber. All rights reserved.
//

import UIKit
import ViewAnimator
import WebKit

extension String{
    func formatDate() -> String {
        
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy/MM/dd"
        
        if let date = inputDateFormatter.date(from: self){
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateStyle = .medium
            outputDateFormatter.timeStyle = .none
            outputDateFormatter.locale = Locale(identifier: "en_US")
            
            return outputDateFormatter.string(from: date)
        }else{
            return "-"
        }
    }
}

extension UITableView {
    
    public func reloadData(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion:{ _ in
            completion()
        })
        
        UIView.animate(views: self.visibleCells, animations: [AnimationType.from(direction: .bottom, offset: 30.0)])
    }
    
    func scroll(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                self.scrollToRow(at: indexPath, at: .top, animated: animated)
            }
        }
    }
}
