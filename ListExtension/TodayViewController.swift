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
    var coreDataManager: CoreDataManager!
    var dataSource: ShoppingListDataSource!
    
    @IBOutlet weak var tableView: UITableView!

    //MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 320, height: 150)
    }

    override func viewWillAppear(animated: Bool) {
        coreDataManager = CoreDataManager()
        dataSource = ShoppingListDataSource(manager: coreDataManager, tableView: tableView, textColor: UIColor.whiteColor())
        tableView.dataSource = dataSource
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
    }
    
    //MARK: IBActions
    @IBAction func didTapScanButton() {
        extensionContext?.openURL(NSURL(string: "barcodeshopping://scan")!, completionHandler: nil)
    }
    
    //MARK: NCWidgetProviding
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        extensionContext?.openURL(NSURL(string: "barcodeshopping://view")!, completionHandler: nil)
    }
}