//
//  Cast+CoreDataClass.swift
//  Assessment
//
//  Created by Sushil K Mishra on 15/02/23.
//
//

import Foundation
import CoreData

@objc(Cast)
public class Cast: NSManagedObject {
    
    class func prepareCastData(dataForSaving: [CastData], movie: Movie) -> [Cast] {
        
        // loop through all the data received from the Web and then convert to managed object and save them
        let castArr = dataForSaving.map{self.createOrUpdateEntityFrom(castData: $0, movie: movie)}
        CoreDataManager.shared.saveContext()
        return castArr
    }
    
    class func createOrUpdateEntityFrom(castData: CastData, movie: Movie) -> Cast{
        
        let cast: Cast!

         let fetchCast: NSFetchRequest<Cast> = Cast.fetchRequest()
        fetchCast.predicate = NSPredicate(format: "movie == %@ && character == %@", movie, castData.character )

        let results = try? CoreDataManager.shared.managedObjectContext.fetch(fetchCast)

         if results?.count == 0 {
            // here you are inserting
             cast = Cast(context: CoreDataManager.shared.managedObjectContext)
         } else {
            // here you are updating
             cast = results?.first
         }

        cast.name = castData.name
        cast.pictureUrl = castData.pictureUrl
        cast.character = castData.character
        cast.movie = movie
        return cast
    }
}
