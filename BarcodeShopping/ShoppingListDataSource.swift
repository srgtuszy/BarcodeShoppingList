//
//  ShoppingListDataSource.swift
//  BarcodeShopping
//
//  Created by Michał Tuszyński on 15/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class ShoppingListDataSource : NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    public let cellIdentifier = "ShoppingTableViewCell"
    weak var tableView: UITableView!
    var fetchedResultsController : NSFetchedResultsController!
    
    init(manager: CoreDataManager, tableView: UITableView) {
        super.init()
        self.tableView = tableView
        createFetchedResultsController(manager.mainContext)
    }
    
    //MARK: Public
    public func itemAtIndexPath(indexPath: NSIndexPath) -> ShoppingItem {
        return fetchedResultsController.objectAtIndexPath(indexPath) as ShoppingItem
    }
    
    //MARK: Internal
    func createFetchedResultsController(context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest(entityName: "ShoppingItem")
        var error: NSError?
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: "shopping_item_source_cache")
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(&error)
        if let error = error {
            fatalError("Couldn't perform fetch: \(error.localizedDescription)")
        }
    }
    
    //MARK: UITableViewDataSource
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as ShoppingItemCell
        let item = itemAtIndexPath(indexPath)
        cell.itemNameLabel.text = item.name
        cell.itemDetailLabel.text = item.details
        cell.itemCountLabel.text = "\(item.count)"
        return cell
    }
    
    //MARK: NSFetchedResultsControllerDelegate
    public func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    public func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath) {
            switch (type) {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
            case .Update:
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
    }
    
    public func controller(controller: NSFetchedResultsController,
        didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
        atIndex sectionIndex: Int,
        forChangeType type: NSFetchedResultsChangeType) {
            let indexSet = NSIndexSet(index: sectionIndex)
            switch (type) {
            case .Insert:
                tableView.insertSections(indexSet, withRowAnimation: .Automatic)
            case .Delete:
                tableView.deleteSections(indexSet, withRowAnimation: .Automatic)
            case .Update:
                tableView.reloadSections(indexSet, withRowAnimation: .Automatic)
            default:
                return
            }
    }
    
    public func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}