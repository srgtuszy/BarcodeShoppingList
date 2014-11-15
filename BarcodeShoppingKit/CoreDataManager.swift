//
//  CoreDataManager.swift
//  BarcodeShopping
//
//  Created by Michał Tuszyński on 15/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

import Foundation
import CoreData

var sharedInstance: CoreDataManager?

public class CoreDataManager {
    public var mainContext: NSManagedObjectContext
    
    public class func createDefaultStack(persistentStoreURL: NSURL) {
        let modelURL = NSBundle.mainBundle().URLForResource("ShoppingListModel", withExtension: "momd")
        let model = NSManagedObjectModel(contentsOfURL: modelURL!)
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
        let persistentStoreOptions = [
            NSMigratePersistentStoresAutomaticallyOption : true,
            NSInferMappingModelAutomaticallyOption : true
        ]
        var error: NSError?
        storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType,
            configuration: nil,
            URL: persistentStoreURL,
            options: persistentStoreOptions,
            error: &error)
        if let error = error {
            fatalError("Could not initialize persistent store: \(error.localizedDescription)")
        }
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = storeCoordinator
        sharedInstance = CoreDataManager(mainContext: context)
    }
    
    public class func sharedManager() -> CoreDataManager {
        return sharedInstance!
    }
    
    init(mainContext: NSManagedObjectContext) {
        self.mainContext = mainContext
    }
    
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