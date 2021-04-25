//
//  AppDelegate.swift
//  MetroNewsTask
//
//  Created by Roman Khodukin on 25.04.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.rootViewController = createNewsNavigationController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func createNewsNavigationController() -> UINavigationController {
        let newsViewController = NewsViewController()
        newsViewController.title = "Новости"
        let navigationController = UINavigationController(rootViewController: newsViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }

}

