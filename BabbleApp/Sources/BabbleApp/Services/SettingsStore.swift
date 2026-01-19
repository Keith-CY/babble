import Foundation

final class SettingsStore {
    private let defaults: UserDefaults
    private let positionKey = "floatingPanelPosition"
    private let historyLimitKey = "historyLimit"
    private let recordTargetAppKey = "recordTargetApp"
    private let autoRefineKey = "autoRefine"
    private let defaultRefineOptionsKey = "defaultRefineOptions"
    private let customPromptsKey = "customPrompts"
    private let defaultLanguageKey = "defaultLanguage"
    private let whisperPortKey = "whisperPort"
    private let clearClipboardAfterCopyKey = "clearClipboardAfterCopy"
    private let playSoundOnCopyKey = "playSoundOnCopy"
    private let hotzoneEnabledKey = "hotzoneEnabled"
    private let hotzoneCornerKey = "hotzoneCorner"
    private let hotzoneHoldSecondsKey = "hotzoneHoldSeconds"

    init(userDefaults: UserDefaults = .standard) {
        self.defaults = userDefaults
    }

    var floatingPanelPosition: FloatingPanelPosition {
        get {
            guard let raw = defaults.string(forKey: positionKey),
                  let value = FloatingPanelPosition(rawValue: raw) else {
                return .top
            }
            return value
        }
        set {
            defaults.set(newValue.rawValue, forKey: positionKey)
        }
    }

    var historyLimit: Int {
        get {
            let stored = defaults.integer(forKey: historyLimitKey)
            return stored > 0 ? stored : 100
        }
        set {
            defaults.set(newValue, forKey: historyLimitKey)
        }
    }

    var recordTargetApp: Bool {
        get { defaults.object(forKey: recordTargetAppKey) as? Bool ?? true }
        set { defaults.set(newValue, forKey: recordTargetAppKey) }
    }

    var autoRefine: Bool {
        get { defaults.object(forKey: autoRefineKey) as? Bool ?? false }
        set { defaults.set(newValue, forKey: autoRefineKey) }
    }

    var defaultRefineOptions: [RefineOption] {
        get {
            let stored = defaults.array(forKey: defaultRefineOptionsKey) as? [String] ?? [RefineOption.punctuate.rawValue]
            return stored.compactMap { RefineOption(rawValue: $0) }
        }
        set {
            defaults.set(newValue.map { $0.rawValue }, forKey: defaultRefineOptionsKey)
        }
    }

    var customPrompts: [RefineOption: String] {
        get {
            let stored = defaults.dictionary(forKey: customPromptsKey) as? [String: String] ?? [:]
            var result: [RefineOption: String] = [:]
            for (key, value) in stored {
                if let option = RefineOption(rawValue: key) {
                    result[option] = value
                }
            }
            return result
        }
        set {
            var stored: [String: String] = [:]
            for (key, value) in newValue {
                stored[key.rawValue] = value
            }
            defaults.set(stored, forKey: customPromptsKey)
        }
    }

    var defaultLanguage: String {
        get { defaults.string(forKey: defaultLanguageKey) ?? "zh" }
        set { defaults.set(newValue, forKey: defaultLanguageKey) }
    }

    var whisperPort: Int {
        get {
            let stored = defaults.integer(forKey: whisperPortKey)
            return stored > 0 ? stored : 8787
        }
        set { defaults.set(newValue, forKey: whisperPortKey) }
    }

    var clearClipboardAfterCopy: Bool {
        get { defaults.object(forKey: clearClipboardAfterCopyKey) as? Bool ?? false }
        set { defaults.set(newValue, forKey: clearClipboardAfterCopyKey) }
    }

    var playSoundOnCopy: Bool {
        get { defaults.object(forKey: playSoundOnCopyKey) as? Bool ?? true }
        set { defaults.set(newValue, forKey: playSoundOnCopyKey) }
    }

    var hotzoneEnabled: Bool {
        get { defaults.object(forKey: hotzoneEnabledKey) as? Bool ?? false }
        set { defaults.set(newValue, forKey: hotzoneEnabledKey) }
    }

    var hotzoneCorner: HotzoneCorner {
        get {
            guard let raw = defaults.string(forKey: hotzoneCornerKey),
                  let value = HotzoneCorner(rawValue: raw) else {
                return .bottomLeft
            }
            return value
        }
        set {
            defaults.set(newValue.rawValue, forKey: hotzoneCornerKey)
        }
    }

    var hotzoneHoldSeconds: Double {
        get {
            let stored = defaults.double(forKey: hotzoneHoldSecondsKey)
            return stored > 0 ? stored : 0.6
        }
        set { defaults.set(newValue, forKey: hotzoneHoldSecondsKey) }
    }
}

enum HotzoneCorner: String, CaseIterable {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}
