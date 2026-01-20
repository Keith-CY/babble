import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var historyLimit: Int {
        didSet { store.historyLimit = historyLimit }
    }

    @Published var autoRefine: Bool {
        didSet { store.autoRefine = autoRefine }
    }

    @Published var defaultRefineOptions: [RefineOption] {
        didSet { store.defaultRefineOptions = defaultRefineOptions }
    }

    @Published var customPrompts: [RefineOption: String] {
        didSet { store.customPrompts = customPrompts }
    }

    @Published var defaultLanguage: String {
        didSet { store.defaultLanguage = defaultLanguage }
    }

    @Published var whisperPort: Int {
        didSet { store.whisperPort = whisperPort }
    }

    @Published var clearClipboardAfterCopy: Bool {
        didSet { store.clearClipboardAfterCopy = clearClipboardAfterCopy }
    }

    @Published var hotzoneEnabled: Bool {
        didSet { store.hotzoneEnabled = hotzoneEnabled }
    }

    @Published var hotzoneCorner: HotzoneCorner {
        didSet { store.hotzoneCorner = hotzoneCorner }
    }

    @Published var hotzoneHoldSeconds: Double {
        didSet { store.hotzoneHoldSeconds = hotzoneHoldSeconds }
    }

    private let store: SettingsStore

    init(store: SettingsStore) {
        self.store = store
        historyLimit = store.historyLimit
        autoRefine = store.autoRefine
        defaultRefineOptions = store.defaultRefineOptions
        customPrompts = store.customPrompts
        defaultLanguage = store.defaultLanguage
        whisperPort = store.whisperPort
        clearClipboardAfterCopy = store.clearClipboardAfterCopy
        hotzoneEnabled = store.hotzoneEnabled
        hotzoneCorner = store.hotzoneCorner
        hotzoneHoldSeconds = store.hotzoneHoldSeconds
    }
}
