import AppIntents

struct AppOpenIntent: AppIntent {
    static let title: LocalizedStringResource = "Open App"
    static var openAppWhenRun: Bool = true
    
    @Parameter()
    var tabType: TabTypeAppEntity?
    
    func perform() async throws -> some IntentResult {
        // select tab
        .result()
    }
}

struct TabTypeAppEntityQuery: EntityQuery {
    func entities(for identifiers: [TabTypeAppEntity.ID]) async throws -> [TabTypeAppEntity] {
        try await suggestedEntities().filter({ identifiers.contains($0.id) })
    }

    func suggestedEntities() async throws -> [TabTypeAppEntity] {
        [
            TabTypeAppEntity(id: "home", title: "ホーム"),
            TabTypeAppEntity(id: "notifications", title: "通知")
        ]
    }
}

struct TabTypeAppEntity: AppEntity {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Tab type")
    static var defaultQuery = TabTypeAppEntityQuery()
    
    let id: String
    let title: String
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }
}



//struct MarkAsReadIntent: ShowInAppSearchResultsIntent {
//    static let title = LocalizedStringResource("全てのメールを既読")
//    
//    var name: String
//    
//    static var isDiscoverable: Bool = false
//    
//    func perform() async throws -> some IntentResult {
//        // process
//        .result()
//    }
//}

//
//// AppIntent -> performのためのIntent
//struct PerformIntent: AppIntent {
//    static var title: LocalizedStringResource {
//        LocalizedStringResource("Open Example App")
//    }
//    
//    // falseの時はbgで実行される
//    static var openAppWhenRun: Bool = true
//    
//    func perform() async throws -> some IntentResult {
//        .result()
//    }
//}
//
//// OpenIntent -> AppEntity, AppEnumを開くためのIntent
//// Openは明示しているのでopenAppWhenRunは不要
//struct OpenUserIntent: OpenIntent {
//    static var title: LocalizedStringResource { "Open User" }
//    static var parameterSummary: some ParameterSummary {
//        Summary("open \(\.$target) \(\.$user2)")
//    }
//    
//    @Parameter(title: "user")
//    var target: User
//    
//    @Parameter(title: "user2")
//    var user2: User
//    
//    func perform() async throws -> some IntentResult {
//        .result()
//    }
//}
//
//// Doubleなどの値も設定できる
//struct OpenPrimitiveIntent: AppIntent {
//    static var title: LocalizedStringResource { "Open Primitive" }
//    
//    @Parameter(title: "value")
//    var target: Double
//    
//    func perform() async throws -> some IntentResult {
//        try await $target.requestConfirmation(for: 100)
//        return .result()
//    }
//}
//
//// AppIntentとOpenIntentの違いは？
//struct OpenUserIntent2: AppIntent {
//    static var title: LocalizedStringResource { "Open User 2" }
//    static var parameterSummary: some ParameterSummary { Summary("open \(\.$user) \(\.$user2)") }
//    
//    @Parameter(title: "user")
//    var user: User
//    
//    @Parameter(title: "user2")
//    var user2: User
//    
//    func perform() async throws -> some IntentResult {
//        .result()
//    }
//}
//
//struct User: AppEntity, Identifiable {
//    static var typeDisplayRepresentation: TypeDisplayRepresentation { .init(name: "User") }
//    static var defaultQuery = UserQuery()
//    
//    var displayRepresentation: DisplayRepresentation
//    
//    let id: String
//    
//    @Property
//    var name: String
//}
//
//
//
//struct UserQuery: EntityQuery {
//    func entities(for identifiers: [String]) async throws -> [User] {
//        .empty
//    }
//    
//    /// Returns all Pokemon. This is what populates the list when you tap on a parameter that accepts a Pokemon.
//    func suggestedEntities() async throws -> [User] {
//        .empty
//    }
//}
//
//
//// AppIntentをShortcutsとして公開する
//// Intentにフェーズを付与している
//struct OpenBookShortcuts: AppShortcutsProvider {
//    //
//    static var appShortcuts: [AppShortcut] {
//        AppShortcut(
//            intent: PerformIntent(),
//            phrases: [
//                "\(.applicationName)を開いて"
//            ],
//            shortTitle: "Open Example App",
//            systemImageName: "apple.logo"
//        )
//    }
//}
