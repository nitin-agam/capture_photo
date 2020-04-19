//
//  AppDelegate.swift
//  PhotoCapture
//
//  Created by Nitin A on 19/04/20.
//  Copyright © 2020 Nitin A. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let controller = HomeController()
        let navigation = UINavigationController(rootViewController: controller)
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()
        return true
    }
}

