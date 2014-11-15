//
//  ShoppingItem.swift
//  BarcodeShopping
//
//  Created by Michał Tuszyński on 15/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

import Foundation
import CoreData

public class ShoppingItem: NSManagedObject {

    @NSManaged public var name: String
    @NSManaged public var details: String
    @NSManaged public var barcode: String
    @NSManaged public var count: Int
    
    public class func findByBarcode(context: NSManagedObjectContext, barcode: String) -> ShoppingItem? {
        let fetchRequest = NSFetchRequest(entityName: "ShoppingItem")
        fetchRequest.predicate = NSPredicate(format: "barcode == %@", barcode)
        var error: NSError?
        let results = context.executeFetchRequest(fetchRequest, error: &error) as [ShoppingItem]
        if let error = error {
            println("Failed to find item by barcode: \(error.localizedDescription)")
            return nil
        }
        return results.last
    }    
}
