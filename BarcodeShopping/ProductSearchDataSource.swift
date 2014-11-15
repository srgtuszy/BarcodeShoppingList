//
//  ProductSearchDataSource.swift
//  BarcodeShopping
//
//  Created by Michał Tuszyński on 15/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class ProductSearchDataSource : NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    public weak var tableView: UITableView!
    let CellIdentifier = "ProductCellIdentifier"
    var fetchedResultsController: NSFetchedResultsController!
    var manager: CoreDataManager!
    var query: String?
    
    public init(manager: CoreDataManager, tableView: UITableView) {
        super.init()
        self.tableView = tableView
        self.manager = manager
        createFetchedResultsController(manager.mainContext)
    }
    
    //MARK: Public
    public func search(query: String) {
        self.query = query
        createFetchedResultsController(manager.mainContext)
    }
    
    public func productAtIndexPath(indexPath: NSIndexPath) -> Product {
        return fetchedResultsController.objectAtIndexPath(indexPath) as Product
    }
    
    //MARK: Internal
    func createFetchedResultsController(context: NSManagedObjectContext) {
        let fetchRequest = createRequest()
        var error: NSError?
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: "product_search_source_cache")
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(&error)
        if let error = error {
            fatalError("Couldn't perform fetch: \(error.localizedDescription)")
        }
    }
    
    func createRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Product")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        if let query = query {
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", query)
        }
        return fetchRequest
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
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as UITableViewCell
            cell.textLabel!.text = productAtIndexPath(indexPath).name
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