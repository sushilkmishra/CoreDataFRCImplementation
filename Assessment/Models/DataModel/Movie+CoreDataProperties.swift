//
//  Movie+CoreDataProperties.swift
//  Assessment
//
//  Created by Sushil K Mishra on 15/02/23.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var budget: Int32
    @NSManaged public var id: Int32
    @NSManaged public var language: String?
    @NSManaged public var overview: String?
    @NSManaged public var posterUrl: String?
    @NSManaged public var rating: Float
    @NSManaged public var releaseDate: String?
    @NSManaged public var revenue: Int32
    @NSManaged public var reviews: Int32
    @NSManaged public var runtime: Int16
    @NSManaged public var staffPick: Bool
    @NSManaged public var title: String?
    @NSManaged public var genres: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var casts: NSSet?
    @NSManaged public var director: Director?

}

// MARK: Generated accessors for casts
extension Movie {

    @objc(addCastsObject:)
    @NSManaged public func addToCasts(_ value: Cast)

    @objc(removeCastsObject:)
    @NSManaged public func removeFromCasts(_ value: Cast)

    @objc(addCasts:)
    @NSManaged public func addToCasts(_ values: NSSet)

    @objc(removeCasts:)
    @NSManaged public func removeFromCasts(_ values: NSSet)

}

extension Movie : Identifiable {

}
