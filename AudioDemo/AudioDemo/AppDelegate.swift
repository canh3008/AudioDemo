//
//  AppDelegate.swift
//  AudioDemo
//
//  Created by Duc Canh on 19/06/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: IntroductionViewController())
        window?.makeKeyAndVisible()
        return true
    }

}

