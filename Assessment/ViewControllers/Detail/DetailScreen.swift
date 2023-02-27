//
//  DetailScreen.swift
//  Assessment
//
//  Created by Sushil K Mishra on 16/02/23.
//

import UIKit

class DetailScreen: ViewController<DetailViewModel> {
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var labelReleaseDate: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tagStackView: UIStackView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelBudget: UILabel!
    @IBOutlet weak var labelRevenue: UILabel!
    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    var movieData : Movie?
    
    private var groupStackView = [UIStackView]()
    private var stockImagesStr: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionAfterLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+600)
        
    }
    private func actionAfterLoad(){
        self.viewModel = DetailViewModel()
        self.updateUI(movieData: movieData)
    }
    
    private func updateUI(movieData: Movie?){
        if let data = movieData {
            ratingView.rating = Double(data.rating)
            updateFavoriteStatusOnUI(data: data)
            if let urlStr = data.posterUrl {
                self.imgPoster.loadImageUsingCacheWithURLString(urlStr, placeHolder: UIImage(named: "dummy.png"))
            }
            if let date = data.releaseDate {
                labelReleaseDate.text = "\(date) \u{2022} \(data.runtime / 60)h\(data.runtime % 60)m"
            }
            if let titleAttributed: NSMutableAttributedString = data.title?.attrbutedStr(attribute: FontAttribute.getAttribute(typeStyle: .nameDetail)) {
                var yearAttributed: NSMutableAttributedString?
                if let date = data.releaseDate {
                    yearAttributed = "(\(date.getYearFromDateStr()))".attrbutedStr(attribute: FontAttribute.getAttribute(typeStyle: .yearDetail) )
                }
                if let year = yearAttributed {
                    titleAttributed.append(year)
                }
                labelTitle.attributedText = titleAttributed
            }
            labelDescription.text = data.overview
            labelBudget.text = "$ \(data.budget)"
            labelRevenue.text = "$ \(data.revenue)"
            labelLanguage.text = data.language
            labelRating.text = String(format: "%.2f(%d)", data.rating, data.reviews)

            if let geners = data.genres {
                stockImagesStr = geners.components(separatedBy: "||")
                setupMultipleDataStack()
            }
        }
    }
    private func updateFavoriteStatusOnUI(data: Movie) {
        if data.isFavorite {
            favoriteButton.setImage(UIImage(named: "Bookmark_s"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "Vector"), for: .normal)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionFavorite(_ sender: Any) {
        if let movie = self.movieData {
            self.viewModel.updateFavoriteStatusForUser(movie: movie)
            updateFavoriteStatusOnUI(data: movie)
        }
    }
    
    private func setupMultipleDataStack() {
        groupStackView.removeAll()
        
        for (_, data) in stockImagesStr.enumerated() {
            
            let labeNameImage = UILabel()
            labeNameImage.font = FontAttribute.getFontNameWithSize(type: .regular, size: 14.0)
            labeNameImage.backgroundColor = UIColor.clear
            labeNameImage.textColor = .black
            labeNameImage.textAlignment = .center
            labeNameImage.text = data
            let isGroupStackView = UIStackView(arrangedSubviews: [ labeNameImage])
            isGroupStackView.axis = .horizontal
            isGroupStackView.alignment = .center
            isGroupStackView.distribution = .fillProportionally
            isGroupStackView.spacing = 10
            groupStackView.append(isGroupStackView)
        }
        for grup in groupStackView {
            tagStackView.addArrangedSubview(grup)
        }
        tagStackView.alignment = .center
        tagStackView.distribution = .fillProportionally
    }
}
