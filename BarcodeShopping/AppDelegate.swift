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
    let distanceThreshold = 1000.0
    var locationManager: CLLocationManager!
    var window: UIWindow?

    //MARK: Application lifecycle
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert,
            categories: nil)
        application.registerUserNotificationSettings(settings)
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
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringVisits()
        locationManager.startUpdatingLocation()
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didVisit visit: CLVisit!) {
        println("New visit")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        if (newLocation.distanceFromLocation(oldLocation) >= distanceThreshold) {
            placeLoader.fetchNearestSupermarket(newLocation.coordinate.latitude,
                longitude: newLocation.coordinate.longitude,
                completionHandler: {(success: Bool!, error: NSError!) in
                    if (success != nil) {
                        let app = UIApplication.sharedApplication()
                        let notification = UILocalNotification()
                        notification.alertBody = "You have things to buy and a shop nearby!"
                        app.presentLocalNotificationNow(notification)
                    }
            })
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Location manager failed: \(error.localizedDescription)")
    }
}