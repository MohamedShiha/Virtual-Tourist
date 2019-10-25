//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by Mohamed Shiha on 8/7/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import UIKit
import CoreData
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let dataController = DataController.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        checkIfFirstLunched()
        dataController.load()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {        
        checkIfFirstLunched()
    }

    
    func checkIfFirstLunched () {
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "hasLunchedBefore") {
            print("App has lunched before")
        } else {
            print("App is lunched for the first time ever")
            userDefaults.set(true, forKey: "hasLunchedBefore")
            // Archieve Data
            let defaultMapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 50), span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
        
            userDefaults.setValue(defaultMapRegion.center.latitude, forKey: "latitude")
            userDefaults.setValue(defaultMapRegion.center.longitude, forKey: "longitude")
            userDefaults.setValue(defaultMapRegion.span.latitudeDelta, forKey: "latitudeDelta")
            userDefaults.setValue(defaultMapRegion.span.longitudeDelta, forKey: "longitudeDelta")
            userDefaults.synchronize()
        }
    }
}

