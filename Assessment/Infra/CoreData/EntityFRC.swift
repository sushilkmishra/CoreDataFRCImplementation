//
//  EntityFRC.swift
//  Assessment
//
//  Created by Sushil K Mishra on 16/02/23.
//

import Foundation
import CoreData

public extension NSManagedObject {
    
    //MARK:- ---- Entity Info -----
    class var entityName: String {
        let name = NSStringFromClass(self).components(separatedBy: ".").last!
        return name;
    }
    
    class var entityDescription: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName, in: CoreDataManager.shared.defaultContext());
    }
    
}
extension NSManagedObject {
    
    
    class func fetchedResultsController() throws -> NSFetchedResultsController<NSFetchRequestResult> {
        
        return try fetchedResultsController(nil)
    }
    
    
    class func fetchedResultsController(_ predicate: NSPredicate?) throws -> NSFetchedResultsController<NSFetchRequestResult> {
        
        return try fetchedResultsController(predicate, sortDescriptor: nil)
    }
    
    
    
    class func fetchedResultsController(_ predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?) throws -> NSFetchedResultsController<NSFetchRequestResult> {
        
        return try fetchedResultsController(predicate, sortDescriptor: sortDescriptor, fetchLimit: 0)
    }
    
    
    
    class func fetchedResultsController(_ predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) throws -> NSFetchedResultsController<NSFetchRequestResult> {
        
        return try fetchedResultsController(predicate, sortDescriptors: sortDescriptors, fetchLimit: 0);
    }
    
    
    class func fetchedResultsController(_ predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?, fetchLimit: Int, includeSubEntities: Bool = true) throws -> NSFetchedResultsController<NSFetchRequestResult> {
        
        let descriptor:[NSSortDescriptor]? = (sortDescriptor != nil) ? [sortDescriptor!] : nil;
        
        return try fetchedResultsController(predicate, sortDescriptors: descriptor, fetchLimit: fetchLimit, includeSubEntities: includeSubEntities);
    }
    
    
    
    class func fetchedResultsController(_ predicate: NSPredicate?,
                                        sortDescriptors: [NSSortDescriptor]?,
                                        fetchLimit: Int,
                                        includeSubEntities: Bool = true) throws -> NSFetchedResultsController<NSFetchRequestResult> {
        
        let fetchRequest = createFetchRequest(predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit, includeSubEntities: includeSubEntities);
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContextForCurrentThread(), sectionNameKeyPath: nil, cacheName: nil);
        
        
        //Perform Fetch
        try frc.performFetch();
        
        return frc;
    }
    
    class func fetchedResultsController(_ predicate: NSPredicate?,
                                        sortDescriptors: [NSSortDescriptor]?,
                                        fetchLimit: Int,
                                        includeSubEntities: Bool = true,
                                        sectionNameKeyPath: String?) throws -> NSFetchedResultsController<NSFetchRequestResult> {
        
        let fetchRequest = createFetchRequest(predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit, includeSubEntities: includeSubEntities);
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContextForCurrentThread(), sectionNameKeyPath: sectionNameKeyPath, cacheName: nil);
        
        
        //Perform Fetch
        try frc.performFetch();
        
        return frc;
    }
    
    
}
extension NSManagedObject {
    class func createFetchRequest(_ predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int, includeSubEntities: Bool) -> NSFetchRequest<NSFetchRequestResult> {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>();
        let entityDescr = self.entityDescription;
        fetchRequest.entity = entityDescr;
        
        fetchRequest.predicate = predicate;
        fetchRequest.sortDescriptors = sortDescriptors;
        
        if(fetchLimit > 0) {
            fetchRequest.fetchLimit = fetchLimit;
            fetchRequest.fetchBatchSize = fetchLimit
        }
        
        fetchRequest.includesPendingChanges = true;
        fetchRequest.includesSubentities = includeSubEntities;
        
        return fetchRequest;
    }
    
    class func managedObjectContextForCurrentThread() -> NSManagedObjectContext {
        return CoreDataManager.shared.defaultContext()
    }
    
}
