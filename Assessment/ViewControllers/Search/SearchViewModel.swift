//
//  SearchViewModel.swift
//  Assessment
//
//  Created by Sushil K Mishra on 16/02/23.
//

import UIKit

class SearchViewModel: ViewModel {
    func updateFavoriteStatusForUser(movie: Movie) {
        movie.isFavorite = !movie.isFavorite
    }
}
