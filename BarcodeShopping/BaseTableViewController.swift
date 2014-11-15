//
//  BaseTableViewController.swift
//  BarcodeShopping
//
//  Created by Michał Tuszyński on 15/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

import BarcodeShoppingKit
import Foundation

class BaseTableViewController : UITableViewController {
    lazy var coreDataManager = CoreDataManager.sharedManager
}