//
//  NotificationManager.swift
//  App
//
//  Created by Tomoya Hirano on 2025/03/15.
//


import Foundation
import UserNotifications

final class NotificationManager {
   static let instance: NotificationManager = NotificationManager()

   // 権限リクエスト
   func requestPermission() {
       UNUserNotificationCenter.current()
           .requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
               print("Permission granted: \(granted)")
           }
   }

   // notificationの登録
   func sendNotification() {
       let content = UNMutableNotificationContent()
       content.body = "You make my everyday so special. (Heart)"
       let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
       UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
   }
}
