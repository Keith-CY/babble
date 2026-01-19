import XCTest
@testable import BabbleApp

@MainActor
final class AppWiringTests: XCTestCase {
    func testMainWindowUsesSharedStores() {
        let coordinator = AppCoordinator()
        XCTAssertNotNil(coordinator.historyStore)
    }
}
