//
//  AppDelegate.swift
//  BarcodeShopping
//
//  Created by Michał Tuszyński on 15/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

import UIKit
import BarcodeShoppingKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
    func setupCoreDataStack() {
        let fileManager = NSFileManager.defaultManager()
        let documentsURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last as NSURL
        let sqliteURL = NSURL(string: "barcode_shopping.sqlite", relativeToURL: documentsURL)
        CoreDataManager.createDefaultStack(sqliteURL!)
    }
}