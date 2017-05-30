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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
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
        
        return true
    }

}

