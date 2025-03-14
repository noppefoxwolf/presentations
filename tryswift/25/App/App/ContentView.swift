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

struct ContentView2: View {
    var body: some View {
        VStack {
            TextField("", text: .constant("---"))
            Spacer()
            HStack {
                HStack {
                    Text("You make my everyday so special.")
                        .font(.body)
                    Image(._032)
                        .resizable()
                        .frame(width: 24, height: 24)
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 3, height: 24)
                        .foregroundStyle(.blue)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .overlay {
                    Capsule()
                        .strokeBorder(style: .init(lineWidth: 1))
                        .foregroundStyle(.separator)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "arrow.up")
                        .foregroundStyle(.white)
                        .bold()
                        .padding(10)
                        .background(Color.blue)
                        .mask(Circle())
                }
            }.padding(.bottom, 8)
        }
    }
}

#Preview {
    ContentView()
}
