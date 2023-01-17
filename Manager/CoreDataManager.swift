//
//  CoreDataManager.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/5/23.
//


import Foundation
import CoreData

class CoreDataManager {
    
    let persistenceContainer: NSPersistentContainer
    static let shared: CoreDataManager = CoreDataManager()
    
    private init() {
        
        persistenceContainer = NSPersistentContainer(name: "MagicBox")
        persistenceContainer.loadPersistentStores { NSEntityDescription, error in
            if let error = error {
                fatalError("Unable to initialize Core Data \(error)")
            }
        }
    }
}
