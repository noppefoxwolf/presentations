//
//  ContentView.swift
//  Example
//
//  Created by Tomoya Hirano on 2021/08/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("画面ジャンプ")) {
                    NavigationLink(destination: EmptyView()) {
                        Text("年末カウントダウン画面")
                    }
                    NavigationLink(destination: EmptyView()) {
                        Text("アチーブメント一覧")
                    }
                    NavigationLink(destination: EmptyView()) {
                        Text("通知設定")
                    }
                    NavigationLink(destination: EmptyView()) {
                        Text("利用規約同意画面")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Debug Menu")
        }
    }
}

struct NestContentView: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: NavigationLink(destination: NavigationLink(destination: NavigationLink(destination: NavigationLink(destination: Text("Followers")) {
                Text("a").navigationTitle("Profile")
            }) {
                Text("a").navigationTitle("Home")
            }) {
                Text("a").navigationTitle("PhoneNumber")
            }) {
                Text("a").navigationTitle("SignUp")
            }) {
                Text("a").navigationTitle("Title")
            }
        }
    }
}

struct ToggleContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: EmptyView()) {
                    HStack {
                        Text("APIサーバー")
                        Spacer()
                        Text("localhost")
                    }
                }
                HStack {
                    Text("ログ送信")
                    Spacer()
                    Toggle(isOn: .constant(false), label: {
                        EmptyView()
                    })
                }
                NavigationLink(destination: EmptyView()) {
                    Text("リセット")
                }
            }.navigationTitle("DebugMenu")
        }
    }
}

struct SettingsContentView: View {
    var body: some View {
        TabView {
            Text("a").tabItem {
                Label("Home", systemImage: "house")
            }
            Text("a").tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            Text("a").tabItem {
                Label("Notification", systemImage: "bell")
            }
            NavigationView {
                List {
                    Section {
                        NavigationLink(destination: EmptyView()) {
                            Text("Account")
                        }
                        NavigationLink(destination: EmptyView()) {
                            Text("Notification")
                        }
                        NavigationLink(destination: EmptyView()) {
                            Text("General")
                        }
                    }
                    Section {
                        NavigationLink(destination: EmptyView()) {
                            Text("DebugMenu")
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Settings")
            }.tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}

struct EnvContentView: View {
    var body: some View {
        Text("Hello, world!")
            .sheet(isPresented: .constant(true), content: {
                NavigationView {
                    List {
                        HStack {
                            Text("OS")
                            Spacer()
                            Text("14.7.1")
                        }
                        HStack {
                            Text("モデル")
                            Spacer()
                            Text("iPhone11 Pro")
                        }
                        HStack {
                            Text("アプリバージョン")
                            Spacer()
                            Text("2.0.0")
                        }
                        HStack {
                            Text("ビルド")
                            Spacer()
                            Text("1123")
                        }
                        
                    }
                    .navigationTitle("Environment")
                }
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
