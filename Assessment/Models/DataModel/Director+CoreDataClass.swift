//
//  Director+CoreDataClass.swift
//  Assessment
//
//  Created by Sushil K Mishra on 15/02/23.
//
//

import Foundation
import CoreData

@objc(Director)
public class Director: NSManagedObject {
    class func createOrUpdateEntityFrom(directorData: DirectorData, movie: Movie) -> Director?{
        
        let director: Director!

         let fetchDirector: NSFetchRequest<Director> = Director.fetchRequest()
        fetchDirector.predicate = NSPredicate(format: "movie == %@", movie )

        let results = try? CoreDataManager.shared.managedObjectContext.fetch(fetchDirector)

         if results?.count == 0 {
            // here you are inserting
             director = Director(context: CoreDataManager.shared.managedObjectContext)
         } else {
            // here you are updating
             director = results?.first
         }

        director.name = directorData.name
        director.pictureUrl = directorData.pictureUrl
        director.movie = movie
        return director
    }
}
