//
//  NewProductViewController.swift
//  BarcodeShopping
//
//  Created by Michał Tuszyński on 15/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

import BarcodeShoppingKit
import Foundation
import UIKit

class NewProductViewController : BaseTableViewController {
    var completionHandler: ((product: Product) -> Void)?
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var detailField: UITextView!
    
    //MARK: IBActions
    @IBAction func saveProduct() {
        if let name = nameField.text {
            let product = Product.create(coreDataManager.mainContext, name: name, details: detailField.text)
            finish(product)
        } else {
            SVProgressHUD.showErrorWithStatus("Please fill out a name!")
        }
    }
    
    //MARK: Internal
    func finish(product: Product) {
        if let completionHandler = completionHandler {
            completionHandler(product: product)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
}