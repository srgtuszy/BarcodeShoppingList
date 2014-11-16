//
//  PlaceLoader.swift
//  BarcodeShopping
//
//  Created by Michał Tuszyński on 15/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

import Foundation

public class PlaceLoader : NetworkLoader {
    let clientId = "PXHXKKYKE4GHTSQKIU31GUKAI2D1JJ504ZE4CU2RYCSSSOOB"
    let clientSecret = "0LZY0JIIJTVECK0CM4H1LMDUGCSM3BHVHSD3TJ0GRORQXUTP"
    let version = "20141116"
    let distanceThreshold = 1000
    
    public func fetchNearestSupermarket(latitude: Double,
        longitude: Double, completionHandler: (result: Bool!, error: NSError!) -> Void) {
            let urlString = "https://api.foursquare.com/v2/venues/search?client_id=\(clientId)&client_secret=\(clientSecret)&v=\(version)&&ll=\(latitude),\(longitude)&radius=\(distanceThreshold)&limit=5"
            println("Loading places: \(urlString)")
            let request = NSURLRequest(URL: NSURL(string: urlString)!)
            let task = session.dataTaskWithRequest(request, completionHandler: {
                (data: NSData!, response: NSURLResponse!, error: NSError!) in
                var success = false
                if (data != nil) {
                    var jsonError: NSError?
                    var json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &jsonError) as AnyObject!
                    if let root = json as NSDictionary? {
                        if let response = root["response"] as NSDictionary? {
                            if let venues = response["venues"] as NSArray? {
                                for var index = 0; index < venues.count; index++ {
                                    let venue = venues.objectAtIndex(index) as NSDictionary
                                    if let categories = venue["categories"] as NSArray? {
                                        for var categoryIndex = 0; categoryIndex    < categories.count; categoryIndex++ {
                                            let category = categories.objectAtIndex(categoryIndex) as NSDictionary
                                            if self.isCategoryAShop(category) {
                                                success = true
                                                break
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(result: success, error: error)
                })
            })
            task.resume()
            
    }
    
    func isCategoryAShop(category: NSDictionary) -> Bool {
        if let name = category["name"] as String? {
            let supermarketRange = name.rangeOfString("supermarket")
            let shopRange = name.rangeOfString("grocery")
            if let supermarketRange = supermarketRange {
                return true
            } else if let shopRange = shopRange {
                return true
            }
        }
        return false
    }
}