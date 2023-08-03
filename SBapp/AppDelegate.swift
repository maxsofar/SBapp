//
//  AppDelegate.swift
//  SBapp
//
//  Created by Max on 28/07/2023.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
  private let actionService = ActionService.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        return true
    }

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {

        if let shortcutItem = options.shortcutItem {
          actionService.action = Action(shortcutItem: shortcutItem)
        }

        let configuration = UISceneConfiguration(
          name: connectingSceneSession.configuration.name,
          sessionRole: connectingSceneSession.role
        )
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}

class SceneDelegate: NSObject, UIWindowSceneDelegate {
  private let actionService = ActionService.shared

  func windowScene(
    _ windowScene: UIWindowScene,
    performActionFor shortcutItem: UIApplicationShortcutItem,
    completionHandler: @escaping (Bool) -> Void
  ) {
    actionService.action = Action(shortcutItem: shortcutItem)
    completionHandler(true)
  }
}


