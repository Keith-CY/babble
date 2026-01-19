import SwiftUI

enum MainWindowRoute: Hashable {
    case history
    case compareEdit
    case settings
}

@MainActor
final class MainWindowRouter: ObservableObject {
    @Published var selection: MainWindowRoute = .history
}

struct MainWindowView: View {
    @StateObject private var router = MainWindowRouter()

    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $router.selection)
        } detail: {
            Text(detailTitle)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var detailTitle: String {
        switch router.selection {
        case .history:
            return "History"
        case .compareEdit:
            return "Compare/Edit"
        case .settings:
            return "Settings"
        }
    }
}
