//
//  AppApp.swift
//  App
//
//  Created by Tomoya Hirano on 2025/03/15.
//

import SwiftUI

@main
struct App: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

import Foundation
import NotificationCenter
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       // リクエストのメソッド呼び出し
       NotificationManager.instance.requestPermission()
       
       UNUserNotificationCenter.current().delegate = self

       return true
   }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.badge, .banner, .list, .sound]
    }

}
