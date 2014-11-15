//
//  MainViewController.swift
//  BarcodeShopping
//
//  Created by Michał Tuszyński on 15/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

import BarcodeShoppingKit
import Foundation
import UIKit

class MainViewController : BaseViewController, ZBarReaderDelegate, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: ShoppingListDataSource!
    
    //MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = ShoppingListDataSource(manager: coreDataManager, tableView: tableView)
        tableView.dataSource = dataSource
    }
    
    //MARK: IBActions
    @IBAction func scanItem() {
        let reader = ZBarReaderViewController()
        reader.readerDelegate = self
        reader.scanner.setSymbology(ZBAR_I25, config: ZBAR_CFG_ENABLE, to: 0)
        presentViewController(reader, animated: true, completion: nil)
    }
    
    //MARK: Internal 
    func handleScannedBarcode(barcode: String) {
        let context = coreDataManager.mainContext
        var item = ShoppingItem.findByBarcode(context, barcode: barcode)
        if let item = item {
            item.count++
            coreDataManager.saveContext()
        } else {
            createNewItem(barcode)
        }
    }
    
    func createNewItem(barcode: String) {
        
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        let results = info[ZBarReaderControllerResults] as NSFastEnumeration
        var foundSymbol: ZBarSymbol?
        for symbol in results as ZBarSymbolSet {
            foundSymbol = symbol as? ZBarSymbol
            break
        }
        if let foundSymbol = foundSymbol {
            handleScannedBarcode(foundSymbol.data)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: ZBarReaderDelegate
    func readerControllerDidFailToRead(reader: ZBarReaderController!, withRetry retry: Bool) {        
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}