//
//  ContentView.swift
//  App
//
//  Created by Tomoya Hirano on 2025/03/15.
//

import SwiftUI

struct ContentView: View {
   var body: some View {
       Text("Local Notification Demo")
           .padding()
       Button(action: { NotificationManager.instance.sendNotification() }) {
           Text("Send Notification!!")
       }
   }
}

