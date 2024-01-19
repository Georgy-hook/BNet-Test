//
//  UImage + kingfisher.swift
//  BNet Test
//
//  Created by Georgy on 15.01.2024.
//

import UIKit
import Kingfisher

extension UIImageView{
    

    func downloadImage(with partOfURL: String){
        self.kf.indicatorType = .activity
        guard let url = URL(string: "\(DefaultBaseURL)\(partOfURL)") else { return }
        
        self.kf.setImage(with: url)
    }
}
