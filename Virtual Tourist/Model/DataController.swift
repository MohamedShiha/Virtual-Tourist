//
//  DataController.swift
//  Mooskine
//
//  Created by Mohamed Shiha on 7/23/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    static let shared = DataController(modelName: "PhotoAlbum")
    
    private let presistentContainer: NSPersistentContainer
    
    var viewContext : NSManagedObjectContext {
        return presistentContainer.viewContext
    }
    
    init(modelName: String) {
        presistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func configureContext() {
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load( _ completion : (() -> Void)? = nil) {
        presistentContainer.loadPersistentStores { (storeDescription, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            self.configureContext()
            completion?()
        }
    }
}
