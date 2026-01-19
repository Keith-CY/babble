// BabbleApp/Sources/BabbleApp/BabbleApp.swift

import SwiftUI

@main
struct BabbleApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            MainWindowView(
                historyStore: coordinator.historyStore,
                settingsStore: coordinator.settingsStore
            )
        }

        Settings {
            EmptyView()
        }
    }
}
