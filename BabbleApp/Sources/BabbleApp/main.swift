// BabbleApp/Sources/BabbleApp/main.swift

import AppKit

// Pure AppKit entry point - no SwiftUI App lifecycle
// This avoids conflicts between SwiftUI's WindowGroup and manual window management

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
