import CoreGraphics

struct FloatingPanelLayout {
    let margin: CGFloat

    func frame(for position: FloatingPanelPosition, panelSize: CGSize, in screen: CGRect) -> CGRect {
        var origin = CGPoint(
            x: screen.midX - panelSize.width / 2,
            y: screen.midY - panelSize.height / 2
        )

        switch position {
        case .top:
            origin.y = screen.maxY - margin - panelSize.height
        case .bottom:
            origin.y = screen.minY + margin
        case .left:
            origin.x = screen.minX + margin
        case .right:
            origin.x = screen.maxX - margin - panelSize.width
        case .center:
            break
        }

        return CGRect(origin: origin, size: panelSize)
    }
}
