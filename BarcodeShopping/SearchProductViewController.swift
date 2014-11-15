//
//  SearchProductViewController.swift
//  BarcodeShopping
//
//  Created by Michał Tuszyński on 15/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

import BarcodeShoppingKit
import Foundation
import UIKit

let CreateProductSegueIdentifier = "CreateProductSegue"

class SearchProductViewController : BaseViewController, UITableViewDelegate {
    var completionHandler: ((product: Product) -> Void)?
    var dataSource: ProductSearchDataSource!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: UIViewController lifecycle
    override func viewDidLoad() {
        dataSource = ProductSearchDataSource(manager: coreDataManager, tableView: tableView)
        tableView.dataSource = dataSource
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    //MARK: IBActions
    @IBAction func createProduct() {
        performSegueWithIdentifier(CreateProductSegueIdentifier, sender: self)
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let product = dataSource.productAtIndexPath(indexPath)
        if let completionHandler = completionHandler {
            completionHandler(product: product)
        }
    }
}