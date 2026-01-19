import XCTest
@testable import BabbleApp

@MainActor
final class HistoryRowViewModelTests: XCTestCase {
    func testEditingDefaultsToSelectedVariant() {
        let record = HistoryRecord.sample(id: "1")
        let model = HistoryRowViewModel(record: record)
        model.selectedVariant = .refined
        model.beginEditing()
        XCTAssertEqual(model.editingText, record.refinedText)
    }
}
