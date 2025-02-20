//
//  BubbleView.swift
//  ComicsApp
//
//  Created by Galya Dodova on 20.02.25.
//

import SwiftUI

struct BubbleView: View {
    @Binding var text: String
    @Binding var position: CGPoint
    @Binding var scale: CGFloat

    var body: some View {
        ZStack {
            SpeechBubble()
                .fill(Color.white)
                .frame(width: 150 * scale, height: 100 * scale)
                .overlay(
                    TextField("Text...", text: $text)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding()
                )
                .shadow(radius: 5)
                .position(position)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.position = value.location
                        }
                )
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            self.scale = value
                        }
                )
        }
    }
}

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
