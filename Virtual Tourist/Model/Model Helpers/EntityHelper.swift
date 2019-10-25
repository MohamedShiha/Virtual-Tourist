//
//  EntityHelper.swift
//  Virtual Tourist
//
//  Created by Mohamed Shiha on 8/28/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation
import CoreData

class Entity<T> where T : NSManagedObject {
    
    class func fetchAlbum(_ predicate : NSPredicate) -> T? {

        let fetchRequest : NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: T.self))

        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "images", ascending: false) ]

        fetchRequest.predicate = predicate

        if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
            if result.count > 0 {
                return result[result.count - 1]
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    class func fetchPins() -> [T]? {

        let fetchRequest : NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: T.self))

        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "latitude", ascending: false) ]

        if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
            if result.count > 0 {
                return result
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func fetchPin(_ predicate : NSPredicate) -> T? {
        
        let fetchRequest : NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: T.self))
        
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "latitude", ascending: false) ]
        
        fetchRequest.predicate = predicate
        
        if let result = try? DataController.shared.viewContext.fetch(fetchRequest) {
            if result.count > 0 {
                return result[0]
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
