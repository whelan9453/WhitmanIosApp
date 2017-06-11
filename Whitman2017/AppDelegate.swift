//
//  AppDelegate.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/4/9.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit
import SideMenu
import Hue
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        resetUserDefault()
        commonUISetting()
        if let _ = UserDefaults.standard.value(forKey: Keys.email) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "GameStart")
            window?.rootViewController = VC
        }
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        return true
    }
    
    func commonUISetting() {
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "Verlag-Bold", size: 20)!,
            NSForegroundColorAttributeName : UIColor(hex: "#f6f3f3")
        ]
        let backImage = UIImage(named: "back")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -3, right: 0))
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        UINavigationBar.appearance().tintColor = UIColor(hex: "#cc3524")
        
        SideMenuManager.menuWidth = 86
        SideMenuManager.menuFadeStatusBar = false
    }

    func resetUserDefault() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier ?? "")
    }
    
    func handleEvent(forRegion region: CLRegion!) {
        //TODO Implement events
        print("Geofence triggered!")
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region)
        }
    }
}
