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
                Button {
                    
                } label: {
                    Text("レベル100の状態で退会する")
                }.foregroundColor(.red)

            }
            .listStyle(.insetGrouped)
            .navigationTitle("DebugMenu")
        }.alert(isPresented: .constant(true)) {
            Alert(title: Text("レベル100の状態で退会する"), message: Text("この操作は取り消す事が出来ません"), primaryButton: .cancel(), secondaryButton: .destructive(Text("実行")))
        }
    }
}


struct BeforeContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: EmptyView()) {
                    Text("レベルを100にする")
                }
                NavigationLink(destination: EmptyView()) {
                    Text("ログアウトAPIを叩く")
                }
                NavigationLink(destination: EmptyView()) {
                    Text("ユーザー情報を消す")
                }
                NavigationLink(destination: EmptyView()) {
                    Text("アプリを終了する")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("DebugMenu")
        }
    }
}

struct OverlayContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Downloading")) {
                    HStack {
                        Text("video.mp4")
                        Spacer()
                        ProgressView(value: 0.4).progressViewStyle(CircularProgressViewStyle())
                    }
                    HStack {
                        Text("video23.mp4")
                        Spacer()
                        ProgressView(value: 0.4).progressViewStyle(CircularProgressViewStyle())
                    }
                    HStack {
                        Text("video3.mp4")
                        Spacer()
                        ProgressView(value: 0.4).progressViewStyle(CircularProgressViewStyle())
                    }
                }
                
                Section(header: Text("Pending")) {
                    HStack {
                        Text("video0.mp4")
                    }
                }
                
                Section(header: Text("Done")) {
                    HStack {
                        Text("data.zip")
                    }
                }
            }.navigationTitle("Downloader")
        }.overlay(overlay(), alignment: .bottom)
    }
    
    @ViewBuilder
    func overlay() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("FPS")
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundColor(.gray)
                        .frame(width: 200, height: 4)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundColor(.red)
                        .frame(width: 120, height: 4)
                    
                    Rectangle()
                        .foregroundColor(.black)
                        .frame(width: 2, height: 16)
                        .offset(x: 140)
                }
                Text("48fps")
            }.font(.callout)
            
            HStack {
                Text("CPU")
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundColor(.gray)
                        .frame(width: 200, height: 4)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundColor(.red)
                        .frame(width: 180, height: 4)
                    
                    Rectangle()
                        .foregroundColor(.black)
                        .frame(width: 2, height: 16)
                        .offset(x: 140)
                }
                Text("98%")
            }.font(.callout)
            
            HStack {
                Text("Thermal")
                Text("Nominal").foregroundColor(.green).bold()
            }.font(.callout)
        }
        .foregroundColor(.white)
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(16)
    }
}

struct ParamsContentView: View {
    var body: some View {
        ZStack {
            HStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 10, style: .circular).frame(width: 20, height: 100)
                RoundedRectangle(cornerRadius: 10, style: .circular).frame(width: 20, height: 80)
                RoundedRectangle(cornerRadius: 10, style: .circular).frame(width: 20, height: 90)
                RoundedRectangle(cornerRadius: 10, style: .circular).frame(width: 20, height: 60)
                RoundedRectangle(cornerRadius: 10, style: .circular).frame(width: 20, height: 100)
                RoundedRectangle(cornerRadius: 10, style: .circular).frame(width: 20, height: 70)
                RoundedRectangle(cornerRadius: 10, style: .circular).frame(width: 20, height: 80)
                RoundedRectangle(cornerRadius: 10, style: .circular).frame(width: 20, height: 50)
            }
            
            VStack {
                Spacer()
                VStack {
                    RoundedRectangle(cornerRadius: 3, style: .circular)
                        .frame(width: 64, height: 6)
                        .foregroundColor(.white)
                    Text("DebugMenu").bold()
                    HStack {
                        Text("Bar")
                        Picker("", selection: .constant(2)) {
                            Text("3").tag(0)
                            Text("5").tag(1)
                            Text("8").tag(2)
                            Text("10").tag(3)
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    HStack {
                        Text("Duration")
                        Slider(value: .constant(0.6))
                        Text("0.6ms")
                    }
                    ColorPicker("Color", selection: .constant(CGColor(_colorLiteralRed: 0, green: 0, blue: 0, alpha: 0)))
                    Button {
                        
                    } label: {
                        Text("エンジニアに設定値を共有").foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(8)
                }
                .padding()
                .background(Material.ultraThickMaterial)
                .background(Color.white.shadow(radius: 4))
                
                

            }
        }.overlay(Button {
            
        } label: {
            Label("Open DebugMenu", systemImage: "ant")
        }.padding(), alignment: .topTrailing)
    }
}

struct OpenURLShortcut {
    static let installURL: URL = URL(string: "https://www.icloud.com/shortcuts/e334c70ce56e465a8445cf336b1315e9")!
    
    let name: String = "OpenURL"
    let url: String
    
    var runURL: URL {
        let text = url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlString = "shortcuts://run-shortcut?name=\(name)&input=text&text=\(text)"
        return URL(string: urlString)!
    }
}

struct RelaunchContentView: View {
    let date: Date = Date()
    
    var body: some View {
        VStack {
            Text("Launched at")
            Text(date, formatter: {
                let f = DateFormatter()
                f.timeStyle = .medium
                return f
            }()).font(.largeTitle)
            
            Divider()
            
            Button {
                UIApplication.shared.open(OpenURLShortcut.installURL, options: [:], completionHandler: nil)
            } label: {
                Text("① Install shortcut")
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(8)

            Button {
                let url = OpenURLShortcut(url: "example://").runURL
                UIApplication.shared.open(url, options: [:]) { _ in
                    exit(0)
                }
//                UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
//                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
//                    exit(0)
//                }
            } label: {
                Text("② Relaunch")
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(8)
        }
    }
}

struct JumpContentView: View {
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
