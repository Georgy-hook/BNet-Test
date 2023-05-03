//
//  AppDelegate.swift
//  BNet Test
//
//  Created by Georgy on 29.04.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        var window: UIWindow?
        // Создаем главный контроллер и назначаем его корневым
          let mainVC = CardViewController() // замените на ваш главный контроллер
          let navController = UINavigationController(rootViewController: mainVC)
          window = UIWindow(frame: UIScreen.main.bounds)
          window?.rootViewController = navController
          window?.makeKeyAndVisible()
          self.window = window
          return true
    }



}

