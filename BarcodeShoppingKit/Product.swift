//
//  Product.swift
//  BarcodeShopping
//
//  Created by Michał Tuszyński on 15/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

import Foundation
import CoreData

public class Product: NSManagedObject {

    @NSManaged public var name: String
    @NSManaged public var details: String
    @NSManaged public var barcode: String
    @NSManaged public var item: ShoppingItem
    
    public class func findByBarcode(context: NSManagedObjectContext, barcode: String) -> Product? {
        let fetchRequest = NSFetchRequest(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "barcode == %@", barcode)
        var error: NSError?
        let results = context.executeFetchRequest(fetchRequest, error: &error) as [Product]
        if let error = error {
            println("Failed to find item by barcode: \(error.localizedDescription)")
            return nil
        }
        return results.last
    }
    
}