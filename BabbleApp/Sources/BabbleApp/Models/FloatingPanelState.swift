import AppKit

enum FloatingPanelStatus: Sendable {
    case idle
    case recording
    case processing
    case pasteFailed
    case error
}

struct FloatingPanelState: Sendable {
    let status: FloatingPanelStatus
    let message: String?

    @MainActor
    var micColor: NSColor {
        switch status {
        case .recording:
            return .systemGreen
        case .pasteFailed, .error:
            return .systemOrange
        default:
            return .secondaryLabelColor
        }
    }
}
