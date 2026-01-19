import Foundation

@MainActor
final class AppCoordinator: ObservableObject {
    let historyStore: HistoryStore
    let settingsStore: SettingsStore
    let voiceInputController: VoiceInputController

    init() {
        self.historyStore = HistoryStore(limit: 100)
        self.settingsStore = SettingsStore()
        self.voiceInputController = VoiceInputController(
            historyStore: historyStore,
            settingsStore: settingsStore
        )
    }
}
