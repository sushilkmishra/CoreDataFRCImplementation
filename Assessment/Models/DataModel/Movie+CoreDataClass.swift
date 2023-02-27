//
//  Movie+CoreDataClass.swift
//  Assessment
//
//  Created by Sushil K Mishra on 15/02/23.
//
//

import Foundation
import CoreData

@objc(Movie)
public class Movie: NSManagedObject {
    
    class func prepare(dataForSaving: [MovieModel]){
        
        // loop through all the data received from the Web and then convert to managed object and save them
        _ = dataForSaving.map{self.createUpdateEntityFrom(movieData: $0)}
        CoreDataManager.shared.saveContext()
    }
    
    
    
    class func updateForStffPick(dataForSaving: [MovieModel]){
        
        // loop through all the data received from the Web and then convert to managed object and save them
        _ = dataForSaving.map{self.createUpdateEntityFrom(movieData: $0, isStaffPick: true)}
        CoreDataManager.shared.saveContext()
    }
    
    
    class func updateFavoriteStatus(movie: Movie) {
        movie.isFavorite = !movie.isFavorite
    }
    
    class func createUpdateEntityFrom(movieData: MovieModel, isStaffPick: Bool = false) -> Movie?{
        
        
        let movie: Movie!
        
        let fetchMovie: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchMovie.predicate = NSPredicate(format: "id == %i", movieData.id )
        
        let results = try? CoreDataManager.shared.managedObjectContext.fetch(fetchMovie)
        
        if results?.count == 0 {
            // here you are inserting
            movie = Movie(context: CoreDataManager.shared.managedObjectContext)
        } else {
            // here you are updating
            movie = results?.first
        }
        
        movie.id = Int32(movieData.id)
        movie.title = movieData.title
        movie.overview = movieData.overview
        movie.budget = movieData.budget
        movie.language = movieData.language
        movie.posterUrl = movieData.posterUrl
        movie.rating = movieData.rating
        movie.releaseDate = movieData.releaseDate
        movie.revenue = movieData.revenue ?? 0
        movie.reviews = Int32(movieData.reviews)
        movie.runtime = Int16(movieData.runtime)
        movie.budget = movieData.budget
        movie.staffPick = isStaffPick
        movie.genres = movieData.genres.joined(separator: "||")
        movie.director = Director.createOrUpdateEntityFrom(directorData: movieData.director, movie: movie)
        _ = Cast.prepareCastData(dataForSaving: movieData.cast, movie: movie)
        return movie
        
        
    }
    
    //MARK: - FRC
    class func fetchMovieFRC(limit : Int = 0, movieType: FeatchType, searchStr: String = "") -> NSFetchedResultsController<NSFetchRequestResult>?{
        
        var predicate: NSPredicate?
        if movieType == .staffPick {
            predicate = NSPredicate(format: "staffPick == %ld", true)
        } else if movieType == .favorite {
            predicate = NSPredicate(format: "isFavorite == %ld", true)
        } else if movieType == .search {
            predicate = NSPredicate(format: "title CONTAINS[c] %@", searchStr)
        } else {
            predicate = nil
        }
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        do{
            return try Movie.fetchedResultsController(predicate, sortDescriptor: sortDescriptor, fetchLimit: limit)
        }
        catch{
            return nil
        }
    }
    
    
}
