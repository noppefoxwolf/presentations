//
//  ContentView.swift
//  iOSDC
//
//  Created by noppe on 2023/08/11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Color.red
            .frame(width: 120, height: 120)
            .mask {
                RoundedRectangle(cornerRadius: 16)
            }
    }
}
struct Health_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 36) {
            Button {
                
            } label: {
                Label("Link with HealthKit", systemImage: "heart.fill")
            }.buttonStyle(.borderedProminent)
            
            Button {
                
            } label: {
                Label("Link with HealthKit", systemImage: "heart.fill")
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(uiColor: UIColor(red: 1.00, green: 0.22, blue: 0.28, alpha: 1.00)))
        }

    }
}

struct Nav_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NavigationLink {
                List {
                    Text("Hello, World!")
                    Text("Hello, World!")
                    Text("Hello, World!")
                }
                .navigationTitle("Title")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {}) {
                            Image(systemName: "plus")
                        }
                    }
                }
            } label: {
                Text("push")
            }
        }
    }
}

struct CustomNav_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .top) {
            List {
                Text("Hello, World!")
                Text("Hello, World!")
                Text("Hello, World!")
            }.offset(y: 20)
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {}) {
                        Image(systemName: "chevron.backward").padding()
                    }
                    Spacer()
                    Text("Title").bold()
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "plus").padding()
                    }
                }
                .frame(height: 44)
                .background(.white)
                Divider()
                
                Spacer()
            }
        }
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

struct DasaTabBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            List {
                ForEach(0..<100, content: { _ in
                    Text("Hello, World!")
                })
            }
            Divider()
            HStack(spacing: 42) {
                Image(systemName: "house.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                Image(systemName: "bell")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                Image(systemName: "envelope")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }
            .padding()
            .foregroundColor(.blue)
        }
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
