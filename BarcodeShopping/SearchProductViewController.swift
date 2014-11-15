//
//  SearchProductViewController.swift
//  BarcodeShopping
//
//  Created by Michał Tuszyński on 15/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

import BarcodeShoppingKit
import Foundation
import UIKit

class SearchProductViewController : BaseViewController {
    var completionHandler: ((product: Product) -> Void)?
}