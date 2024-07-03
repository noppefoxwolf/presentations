//
//  ExampleApp.swift
//  Example
//
//  Created by Tomoya Hirano on 2024/06/23.
//

import SwiftUI
import SwiftData
import AppIntents

@main
struct ExampleApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

struct Intent: AppIntent {
    static let title: LocalizedStringResource = "Hello"
    
    static var isDiscoverable: Bool = false
    
    func perform() async throws -> some IntentResult {
        print("OK")
        return .result()
    }
}
