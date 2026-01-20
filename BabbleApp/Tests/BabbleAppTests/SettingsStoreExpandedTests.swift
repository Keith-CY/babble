import Combine
import XCTest
@testable import BabbleApp

@MainActor
final class SettingsStoreExpandedTests: XCTestCase {
    func testPersistsHistoryLimit() {
        let defaults = UserDefaults(suiteName: "SettingsStoreExpandedTests")!
        defaults.removePersistentDomain(forName: "SettingsStoreExpandedTests")
        let store = SettingsStore(userDefaults: defaults)

        store.historyLimit = 200
        XCTAssertEqual(store.historyLimit, 200)
    }

    func testDefaultsHotzoneHoldSecondsToTwoSeconds() {
        let defaults = UserDefaults(suiteName: "SettingsStoreExpandedTests")!
        defaults.removePersistentDomain(forName: "SettingsStoreExpandedTests")
        let store = SettingsStore(userDefaults: defaults)

        XCTAssertEqual(store.hotzoneHoldSeconds, 2.0, accuracy: 0.001)
    }

    func testPublishesCopySettingsChanges() {
        let defaults = UserDefaults(suiteName: "SettingsStoreExpandedTests")!
        defaults.removePersistentDomain(forName: "SettingsStoreExpandedTests")
        let store = SettingsStore(userDefaults: defaults)

        var cancellables = Set<AnyCancellable>()

        let clearClipboardExpectation = expectation(description: "publishes clearClipboardAfterCopy change")
        store.objectWillChange.first().sink {
            clearClipboardExpectation.fulfill()
        }.store(in: &cancellables)

        store.clearClipboardAfterCopy.toggle()
        wait(for: [clearClipboardExpectation], timeout: 1.0)
    }

    func testPersistsCustomPrompts() {
        let defaults = UserDefaults(suiteName: "SettingsStoreExpandedTests")!
        defaults.removePersistentDomain(forName: "SettingsStoreExpandedTests")
        let store = SettingsStore(userDefaults: defaults)

        store.customPrompts = [.correct: "Custom correct prompt"]
        XCTAssertEqual(store.customPrompts[.correct], "Custom correct prompt")

        // Verify it persists by creating a new store with same defaults
        let store2 = SettingsStore(userDefaults: defaults)
        XCTAssertEqual(store2.customPrompts[.correct], "Custom correct prompt")
    }
}
