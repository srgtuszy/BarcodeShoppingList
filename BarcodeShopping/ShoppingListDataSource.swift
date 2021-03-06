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
    var manager: CoreDataManager!
    var fetchedResultsController : NSFetchedResultsController!
    var textColor: UIColor!
    
    public init(manager: CoreDataManager, tableView: UITableView, textColor: UIColor) {
        super.init()
        self.manager = manager
        self.tableView = tableView
        self.textColor = textColor
        createFetchedResultsController(manager.mainContext)
    }
    
    //MARK: Public
    public func itemAtIndexPath(indexPath: NSIndexPath) -> ShoppingItem {
        return fetchedResultsController.objectAtIndexPath(indexPath) as ShoppingItem
    }
    
    public func refresh() {
        var error: NSError?
        fetchedResultsController.performFetch(&error)
        if let error = error {
            fatalError("Couldn't perform fetch: \(error.localizedDescription)")
        }
    }
    
    //MARK: Internal
    func createFetchedResultsController(context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest(entityName: "ShoppingItem")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "count", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        refresh()
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
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let item = itemAtIndexPath(indexPath)
            manager.mainContext.deleteObject(item)
            manager.saveContext()
        }
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell
        let item = itemAtIndexPath(indexPath)
        cell.textLabel!.text = "\(item.product.name), x\(item.count)"
        cell.textLabel!.textColor = textColor
        cell.detailTextLabel!.text = item.product.details
        cell.detailTextLabel!.textColor = textColor
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