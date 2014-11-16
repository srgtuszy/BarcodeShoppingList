//
//  ProductLoader.swift
//  BarcodeShopping
//
//  Created by Michał Tuszyński on 15/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

import Foundation

public class ProductLoader : NetworkLoader {
    let apiKey = "a3a6326543235dafaa87a106a554769d"
    
    public override init() {
        super.init()
    }
    
    public func loadProductInfo(barcode: String,
        completionHandler: (product: ProductMetaData!, error: NSError!) -> Void) {
        let urlString = "http://api.upcdatabase.org/json/\(apiKey)/\(barcode)"
        println("Pulling product info from: \(urlString)")
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 15)
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data: NSData!, response: NSURLResponse!, error: NSError!) in
            var product: ProductMetaData?
            if (data != nil) {
                var jsonError: NSError?
                var productJson: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &jsonError) as AnyObject!
                if let productData = productJson as NSDictionary? {
                    if let name = productData["itemname"] as String? {
                        var details: String?
                        if let description = productData["description"] as String? {
                            details = description
                        }
                        product = ProductMetaData(name: name, details: details)
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(product: product, error: error)
            })
        })
        task.resume()
    }
}