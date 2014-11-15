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

class MainViewController : BaseViewController, ZBarReaderDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: IBActions
    @IBAction func scanItem() {
        let reader = ZBarReaderViewController()
        reader.readerDelegate = self
        reader.scanner.setSymbology(ZBAR_I25, config: ZBAR_CFG_ENABLE, to: 0)
        showViewController(reader, sender: self)
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
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        let results = editingInfo[ZBarReaderControllerResults] as [ZBarSymbol]
        var symbol: ZBarSymbol?
        for foundSymbol: ZBarSymbol in results {
            symbol = foundSymbol
            break
        }
        if let symbol = symbol {
            handleScannedBarcode(symbol.data)
        }
    }
    
    //MARK: ZBarReaderDelegate
    func readerControllerDidFailToRead(reader: ZBarReaderController!, withRetry retry: Bool) {        
    }
}