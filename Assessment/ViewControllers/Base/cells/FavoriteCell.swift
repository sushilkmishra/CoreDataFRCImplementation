//
//  FavoriteCell.swift
//  Assessment
//
//  Created by Sushil K Mishra on 16/02/23.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPoster: UIImageView!
    func configureData(movieData: Movie) {
        if let urlStr = movieData.posterUrl {
            self.imgPoster.loadImageUsingCacheWithURLString(urlStr, placeHolder: UIImage(named: "dummy.png"))
            imgPoster.setRadius(radius: 14.0)
        }
    }
}
