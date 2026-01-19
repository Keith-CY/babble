// BabbleApp/Sources/BabbleApp/Services/ProcessManager.swift

import Foundation

actor WhisperProcessManager {
    private var process: Process?
    private var isRunning = false

    private let whisperServicePath: URL
    private let pythonPath: URL

    init() {
        // Locate whisper-service relative to app bundle or development path
        let bundle = Bundle.main
        let fileManager = FileManager.default

        // Try bundle resources first (for packaged .app)
        if let resourcePath = bundle.resourcePath {
            let bundledPath = URL(fileURLWithPath: resourcePath)
                .appendingPathComponent("whisper-service")
            if fileManager.fileExists(atPath: bundledPath.path) {
                whisperServicePath = bundledPath
                // Use venv python if available, otherwise system python
                let venvPython = bundledPath.appendingPathComponent(".venv/bin/python3")
                if fileManager.fileExists(atPath: venvPython.path) {
                    pythonPath = venvPython
                } else {
                    pythonPath = URL(fileURLWithPath: "/usr/bin/python3")
                }
                return
            }
        }

        // Development fallback: look for whisper-service relative to current directory
        // This handles swift run and scripts/dev.sh scenarios
        let devPath = URL(fileURLWithPath: fileManager.currentDirectoryPath)
            .deletingLastPathComponent()
            .appendingPathComponent("whisper-service")
        whisperServicePath = devPath

        // Use venv python if available (dependencies are installed there)
        let venvPython = devPath.appendingPathComponent(".venv/bin/python3")
        if fileManager.fileExists(atPath: venvPython.path) {
            pythonPath = venvPython
        } else {
            pythonPath = URL(fileURLWithPath: "/usr/bin/python3")
        }
    }

    func start() async throws {
        // If process crashed, reset state
        if isRunning && !(process?.isRunning ?? false) {
            isRunning = false
            process = nil
        }

        guard !isRunning else { return }

        let serverPath = whisperServicePath.appendingPathComponent("server.py")

        guard FileManager.default.fileExists(atPath: serverPath.path) else {
            throw ProcessManagerError.serviceNotFound(serverPath.path)
        }

        let process = Process()
        process.executableURL = pythonPath
        process.arguments = [serverPath.path]
        process.currentDirectoryURL = whisperServicePath

        // Discard output to prevent pipe buffer from filling and blocking process
        process.standardOutput = FileHandle.nullDevice
        process.standardError = FileHandle.nullDevice

        try process.run()
        self.process = process
        isRunning = true

        // Wait a moment for server to start
        try await Task.sleep(nanoseconds: 2_000_000_000)
    }

    func stop() {
        process?.terminate()
        process = nil
        isRunning = false
    }

    func ensureRunning() async throws {
        if !running {
            try await start()
        }
    }

    var running: Bool {
        isRunning && (process?.isRunning ?? false)
    }
}

enum ProcessManagerError: Error, LocalizedError {
    case serviceNotFound(String)
    case startFailed(String)

    var errorDescription: String? {
        switch self {
        case .serviceNotFound(let path):
            return "Whisper service not found at: \(path)"
        case .startFailed(let message):
            return "Failed to start Whisper service: \(message)"
        }
    }
}
