//
//  ShoppingItemCell.swift
//  BarcodeShopping
//
//  Created by Michał Tuszyński on 15/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

import Foundation
import UIKit

public class ShoppingItemCell : UITableViewCell {
    @IBOutlet public weak var itemImageView: UIImageView!
    @IBOutlet public weak var itemNameLabel: UILabel!
    @IBOutlet public weak var itemCountLabel: UILabel!
    @IBOutlet public weak var itemDetailLabel: UILabel!
}