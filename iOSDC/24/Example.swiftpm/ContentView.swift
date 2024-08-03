import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                let user = User()
                print(user.name)
                let selector = Selector("_setUserName:")
                user.perform(selector, with: "John Doe")
                print(user.name)
                
            }
    }
}

struct _TestView: View {
    var body: some View {
        Text("")
    }
}

final class User: NSObject {
    private(set) var name: String = "Placeholder"
    
    @objc(_setUserName:)
    private func _setUserName(_ name: String) {
        self.name = name
    }
}
