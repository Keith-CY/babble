// BabbleApp/Sources/BabbleApp/AppDelegate.swift

import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
    }

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "mic.fill", accessibilityDescription: "Babble")
            button.action = #selector(togglePopover)
            button.target = self
        }

        // Create menu
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Start Recording", action: #selector(startRecording), keyEquivalent: "r"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))

        statusItem?.menu = menu
    }

    @objc private func togglePopover() {
        // Will implement floating panel later
    }

    @objc private func startRecording() {
        print("Recording started...")
    }

    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
}
