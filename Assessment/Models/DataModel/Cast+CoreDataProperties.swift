//
//  Cast+CoreDataProperties.swift
//  Assessment
//
//  Created by Sushil K Mishra on 15/02/23.
//
//

import Foundation
import CoreData


extension Cast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cast> {
        return NSFetchRequest<Cast>(entityName: "Cast")
    }

    @NSManaged public var character: String?
    @NSManaged public var name: String?
    @NSManaged public var pictureUrl: String?
    @NSManaged public var movie: Movie?

}

extension Cast : Identifiable {

}
