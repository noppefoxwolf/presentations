//
//  ContentView.swift
//  iOSDC
//
//  Created by noppe on 2023/08/11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct DesignStack_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            VStack {
                Text("Custom UI")
                    .bold()
                    .padding()
                    .background(.yellow)
                Text("UIKit / SwiftUI")
                    .bold()
                    .padding()
                    .background(.orange)
                Text("iOS UI Design")
                    .bold()
                    .padding()
                    .background(.red)
            }
            Text("UI")
                .background(.blue)
        }.padding()
    }
}

struct Dasa_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            VStack {
                Text("名前：佐藤太郎")
                Image("Untitled")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(50)
            }
            VStack {
                Text("フォロー中")
                Text("カテゴリー：友達")
            }
            Image(systemName: "plus")
                .bold()
                .font(.system(size: 40))
                .background(.green)
                .cornerRadius(20)
        }
        .padding()
        .background(Color(uiColor: .yellow))
        .cornerRadius(5)
        .shadow(color: .black, radius: 20, x: 0, y: 0)
        .padding(25)
        
            
    }
}
    

struct Segment_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 0) {
            Capsule()
                .overlay(content: {
                    Text("Home")
                        .foregroundColor(Color.white)
                })
                .padding(2)
            Capsule()
                .fill(.clear)
                .overlay(content: {
                    Text("Profile")
                        .foregroundColor(.secondary)
                })
                .padding(2)
            Capsule()
                .fill(.clear)
                .overlay(content: {
                    Text("Settings")
                        .foregroundColor(.secondary)
                })
                .padding(2)
        }
        .overlay {
            Capsule()
                .stroke()
        }
        .frame(height: 36)
        .fixedSize(horizontal: false, vertical: true)
        .padding()
    }
}
