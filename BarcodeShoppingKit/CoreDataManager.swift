//
//  CoreDataManager.swift
//  BarcodeShopping
//
//  Created by Michał Tuszyński on 15/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataManager {
    public var mainContext: NSManagedObjectContext!

    public class var sharedManager: CoreDataManager {
        struct Singleton {
            static let instance = CoreDataManager()
        }
        return Singleton.instance
    }
    
    public init() {
        let fileManager = NSFileManager.defaultManager()
        let documentsURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last as NSURL
        let sqliteURL = NSURL(string: "barcode_shopping.sqlite", relativeToURL: documentsURL)
        let modelURL = NSBundle(forClass: self.dynamicType).URLForResource("ShoppingListModel", withExtension: "momd")
        let model = NSManagedObjectModel(contentsOfURL: modelURL!)
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
        let persistentStoreOptions = [
            NSMigratePersistentStoresAutomaticallyOption : true,
            NSInferMappingModelAutomaticallyOption : true
        ]
        var error: NSError?
        storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType,
            configuration: nil,
            URL: sqliteURL,
            options: persistentStoreOptions,
            error: &error)
        if let error = error {
            fatalError("Could not initialize persistent store: \(error.localizedDescription)")
        }
        mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = storeCoordinator
    }
    
    //MARK: Public
    public func saveContext() -> Bool {
        var error: NSError?
        mainContext.save(&error)
        if let error = error {
            println("Failed to save context: \(error.localizedDescription)")
            return false
        }
        return true
    }
}