//
//  MainViewController.swift
//  BarcodeShopping
//
//  Created by Michał Tuszyński on 15/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

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
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
    }
    
    //MARK: ZBarReaderDelegate
    func readerControllerDidFailToRead(reader: ZBarReaderController!, withRetry retry: Bool) {
        
    }
}