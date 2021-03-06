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

    @NSManaged public var count: Int32
    @NSManaged public var product: Product
    
    public class func create(context: NSManagedObjectContext) -> ShoppingItem {
        let item = NSEntityDescription.insertNewObjectForEntityForName("ShoppingItem", inManagedObjectContext: context) as ShoppingItem
        item.count = 1
        return item
    }
}
