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

let NewProductSegue = "NewProductSegue"

class MainViewController : BaseViewController, ZBarReaderDelegate, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: ShoppingListDataSource!
    var barcode: String!
    
    //MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = ShoppingListDataSource(manager: coreDataManager, tableView: tableView, textColor: UIColor.blackColor())
        tableView.dataSource = dataSource
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewController = segue.destinationViewController as NewProductViewController
        viewController.completionHandler = {[weak self] (product: Product) in
            product.item = ShoppingItem.create(self!.coreDataManager.mainContext)
            product.barcode = self!.barcode
            self!.barcode = nil
            self!.coreDataManager.saveContext()
        }
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
        var product = Product.findByBarcode(context, barcode: barcode)
        if let product = product {
            if let item = product.item {
                item.count++
                coreDataManager.saveContext()
            } else {
                product.item = ShoppingItem.create(self.coreDataManager.mainContext)
            }
            SVProgressHUD.showSuccessWithStatus("Product added!")
        } else {
            self.barcode = barcode
            performSegueWithIdentifier(NewProductSegue, sender: self)
        }
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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }    
}