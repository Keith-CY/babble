import AppKit
import SwiftUI

enum HistoryTextVariant: String, CaseIterable, Hashable {
    case raw = "原文"
    case refined = "润色"
}

@MainActor
final class HistoryRowViewModel: ObservableObject {
    @Published var selectedVariant: HistoryTextVariant = .raw
    @Published var editingText = ""
    @Published var isEditing = false

    let record: HistoryRecord

    init(record: HistoryRecord) {
        self.record = record
    }

    var selectedText: String {
        switch selectedVariant {
        case .raw:
            return record.rawText
        case .refined:
            return record.refinedText
        }
    }

    func beginEditing() {
        editingText = selectedText
        isEditing = true
    }

    func finishEditing() {
        isEditing = false
    }
}

struct HistoryRowView: View {
    @StateObject private var model: HistoryRowViewModel
    private let playSoundOnCopy: Bool
    private let clearClipboardAfterCopy: Bool

    init(record: HistoryRecord, playSoundOnCopy: Bool, clearClipboardAfterCopy: Bool) {
        _model = StateObject(wrappedValue: HistoryRowViewModel(record: record))
        self.playSoundOnCopy = playSoundOnCopy
        self.clearClipboardAfterCopy = clearClipboardAfterCopy
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Picker("", selection: $model.selectedVariant) {
                    ForEach(HistoryTextVariant.allCases, id: \.self) { variant in
                        Text(variant.rawValue).tag(variant)
                    }
                }
                .pickerStyle(.segmented)

                Spacer()

                Button("编辑") {
                    model.beginEditing()
                }
            }

            if model.isEditing {
                TextEditor(text: $model.editingText)
                    .frame(minHeight: 80)
            } else {
                Text(model.selectedText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            HStack {
                Spacer()
                Button("复制") {
                    copyCurrentText()
                }
            }
        }
        .padding(.vertical, 8)
    }

    private func copyCurrentText() {
        let text = model.isEditing ? model.editingText : model.selectedText
        PasteService.copyToClipboard(text)

        if playSoundOnCopy {
            NSSound.beep()
        }

        if clearClipboardAfterCopy {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                NSPasteboard.general.clearContents()
            }
        }

        if model.isEditing {
            model.finishEditing()
        }
    }
}
