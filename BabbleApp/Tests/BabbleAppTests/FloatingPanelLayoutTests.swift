import CoreGraphics
import XCTest
@testable import BabbleApp

final class FloatingPanelLayoutTests: XCTestCase {
    func testPositionFramesUseScreenBoundsWithMargin() {
        let screen = CGRect(x: 0, y: 0, width: 1000, height: 800)
        let size = CGSize(width: 240, height: 64)
        let margin: CGFloat = 20

        let layout = FloatingPanelLayout(margin: margin)

        XCTAssertEqual(
            layout.frame(for: .top, panelSize: size, in: screen).origin.y,
            screen.maxY - margin - size.height
        )
        XCTAssertEqual(
            layout.frame(for: .bottom, panelSize: size, in: screen).origin.y,
            screen.minY + margin
        )
    }
}
