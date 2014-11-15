//
//  ProductLoader.swift
//  BarcodeShopping
//
//  Created by Michał Tuszyński on 15/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

import Foundation

public class ProductLoader {
    let apiKey = "a3a6326543235dafaa87a106a554769d"
    var session: NSURLSession
    
    public init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
    }
    
    public func loadProductInfo(barcode: String,
        completionHandler: (product: ProductMetaData?, error: NSError?) -> Void) {
        let urlString = "http://api.upcdatabase.org/json/\(apiKey)/\(barcode)"
        let request = NSURLRequest(URL: NSURL(string: urlString)!)
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data: NSData!, response: NSURLResponse!, error: NSError!) in
            if (data != nil) {
                
            }
        })
        task.resume()
    }
}