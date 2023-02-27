//
//  MovieCell.swift
//  Assessment
//
//  Created by Sushil K Mishra on 16/02/23.
//

import UIKit

class MovieCell: UITableViewCell {
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonFavorite: AppButton!
    @IBOutlet weak var viewRating: FloatRatingView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgPoster.setRadius(radius: 10.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureData(movieData: Movie) {
        if let urlStr = movieData.posterUrl {
            self.imgPoster.loadImageUsingCacheWithURLString(urlStr, placeHolder: UIImage(named: "dummy.png"))
        }
        labelTitle.text = movieData.title
        viewRating.rating = Double(movieData.rating)
        if let date = movieData.releaseDate {
            labelReleaseDate.text = date.getYearFromDateStr()
        } else{
            labelReleaseDate.text = ""
        }
        if movieData.isFavorite {
            buttonFavorite.setImage(UIImage(named: "Bookmark_s"), for: .normal)
        } else {
            buttonFavorite.setImage(UIImage(named: "Vector"), for: .normal)
        }
    }

}
