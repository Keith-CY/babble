struct PanelStateReducer {
    func finalPanelStateAfterDelay(
        pasteSucceeded: Bool,
        current: FloatingPanelState,
        shouldApply: Bool
    ) -> FloatingPanelState {
        guard shouldApply else {
            return current
        }

        if pasteSucceeded {
            return FloatingPanelState(status: .idle, message: nil)
        }
        return current
    }
}
