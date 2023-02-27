//
//  HomeViewModel.swift
//  Assessment
//
//  Created by Sushil K Mishra on 15/02/23.
//

import Foundation
class HomeViewModel: ViewModel {
    
    func updateData() {
        if let moviesArray = self.loadJson("Movies") {
            Movie.prepare(dataForSaving: moviesArray)
        }
        if let staffPickMoviesArray = self.loadJson("StaffPick") {
            Movie.updateForStffPick(dataForSaving: staffPickMoviesArray)
        }
        printDatabasePath()
    }
    private func loadJson(_ fileName: String) -> [MovieModel]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonArray = try decoder.decode([MovieModel].self, from: data)
                return jsonArray
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    //just for checking database
    private func printDatabasePath() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        print(documentsDirectory)
    }
    
    func updateFavoriteStatusForUser(movie: Movie) {
        movie.isFavorite = !movie.isFavorite
    }
    
}

