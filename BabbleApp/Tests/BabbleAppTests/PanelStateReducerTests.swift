import XCTest
@testable import BabbleApp

final class PanelStateReducerTests: XCTestCase {
    func testKeepsPasteFailedAfterDelay() {
        let reducer = PanelStateReducer()
        let state = FloatingPanelState(status: .pasteFailed, message: "你可以在目标位置粘贴")

        let result = reducer.finalPanelStateAfterDelay(
            pasteSucceeded: false,
            current: state,
            shouldApply: true
        )

        XCTAssertEqual(result.status, .pasteFailed)
    }

    func testSkipsResetWhenNotCompleted() {
        let reducer = PanelStateReducer()
        let state = FloatingPanelState(status: .recording, message: nil)

        let result = reducer.finalPanelStateAfterDelay(
            pasteSucceeded: true,
            current: state,
            shouldApply: false
        )

        XCTAssertEqual(result.status, .recording)
    }
}
