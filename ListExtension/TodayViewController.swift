//
//  TodayViewController.swift
//  ListExtension
//
//  Created by Michał Tuszyński on 15/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

import UIKit
import BarcodeShoppingKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate {
    let coreDataManager = CoreDataManager.sharedManager
    var dataSource: ShoppingListDataSource!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: UITableViewDataSource
    override func viewDidLoad() {
        super.viewDidLoad()        
        dataSource = ShoppingListDataSource(manager: coreDataManager, tableView: tableView)
        tableView.dataSource = dataSource        
    }
    
    override func viewDidAppear(animated: Bool) {
        dataSource = ShoppingListDataSource(manager: coreDataManager, tableView: tableView)
        tableView.dataSource = dataSource
    }
    
    //MARK: NCWidgetProviding
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}