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

class SearchProductViewController : BaseViewController, UITableViewDelegate, UISearchBarDelegate {
    var completionHandler: ((product: Product) -> Void)?
    var dataSource: ProductSearchDataSource!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: UIViewController lifecycle
    override func viewDidLoad() {
        dataSource = ProductSearchDataSource(manager: coreDataManager, tableView: tableView)
        tableView.dataSource = dataSource
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController = segue.destinationViewController as NewProductViewController
        viewController.completionHandler = {[unowned self] (product: Product) in
            self.finishWithProduct(product)
        }
    }
    
    //MARK: IBActions
    @IBAction func createProduct() {
        performSegueWithIdentifier(CreateProductSegueIdentifier, sender: self)
    }
    
    //MARK: Internal
    func finishWithProduct(product: Product) {
        if let completionHandler = self.completionHandler {
            completionHandler(product: product)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        finishWithProduct(dataSource.productAtIndexPath(indexPath))
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Type product name"
        searchBar.delegate = self
        return searchBar
    }
    
    //MARK: UISearchBarDelegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource.search(searchText)
    }
}