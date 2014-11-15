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
        completionHandler: (product: ProductMetaData!, error: NSError!) -> Void) {
        let urlString = "http://api.upcdatabase.org/json/\(apiKey)/\(barcode)"
        let request = NSURLRequest(URL: NSURL(string: urlString)!)
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data: NSData!, response: NSURLResponse!, error: NSError!) in
            if (data != nil) {
                var jsonError: NSError?
                var productJson: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &jsonError) as AnyObject!
                if let productData = productJson as NSDictionary? {
                    if let name = productData["itemname"] as String? {
                        var details: String?
                        if let description = productData["description"] as String? {
                            details = description
                        }
                        let product = ProductMetaData(name: name, details: details)
                        dispatch_async(dispatch_get_main_queue(), {
                            completionHandler(product: product, error: nil)
                        })
                    }
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(product: nil, error: error)
                })
            }
        })
        task.resume()
    }
}