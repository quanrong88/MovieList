//
//  AppDelegate.swift
//  MovieList
//
//  Created by Tạ Minh Quân on 17/03/2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
        window.makeKeyAndVisible()
        return true
    }
}

