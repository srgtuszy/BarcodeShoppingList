//
//  AppDelegate.swift
//  BarcodeShopping
//
//  Created by Michał Tuszyński on 15/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

import UIKit
import CoreLocation
import BarcodeShoppingKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    let placeLoader: PlaceLoader = PlaceLoader()
    var locationManager: CLLocationManager!
    var window: UIWindow?

    //MARK: Application lifecycle
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupLocationManager()
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        if url.scheme? == "barcodeshopping" {
            NSNotificationCenter
                .defaultCenter()                
                .postNotificationName("ScanWidgetTapped", object: nil)
            return true
        }
        return false
    }
    
    //MARK: Application setup
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringVisits()
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didVisit visit: CLVisit!) {
        
    }
}