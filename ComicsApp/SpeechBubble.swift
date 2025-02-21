import SwiftUI
struct SpeechBubble: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let bubbleRect = rect.insetBy(dx: 10, dy: 10)
        path.addRoundedRect(in: bubbleRect, cornerSize: CGSize(width: 20, height: 20))

        let tailWidth: CGFloat = 20
        let tailHeight: CGFloat = 10
        let tailStart = CGPoint(x: bubbleRect.midX - tailWidth / 2, y: bubbleRect.maxY)
        let tailEnd = CGPoint(x: bubbleRect.midX + tailWidth / 2, y: bubbleRect.maxY)
        
        path.move(to: tailStart)
        path.addLine(to: CGPoint(x: bubbleRect.midX, y: bubbleRect.maxY + tailHeight))
        path.addLine(to: tailEnd)
        path.closeSubpath()

        return path
    }
}
