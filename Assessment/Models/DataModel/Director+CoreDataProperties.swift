//
//  Director+CoreDataProperties.swift
//  Assessment
//
//  Created by Sushil K Mishra on 15/02/23.
//
//

import Foundation
import CoreData


extension Director {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Director> {
        return NSFetchRequest<Director>(entityName: "Director")
    }

    @NSManaged public var name: String?
    @NSManaged public var pictureUrl: String?
    @NSManaged public var movie: Movie?

}

extension Director : Identifiable {

}
