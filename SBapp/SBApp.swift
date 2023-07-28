//
//  SBappApp.swift
//  SBapp
//
//  Created by Max on 21/06/2023.
//

import SwiftUI

@main
struct SBApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private let actionService = ActionService.shared
    
    var body: some Scene {
        WindowGroup {
            StudyBuddy()
                .environmentObject(actionService)
        }
    }
}
