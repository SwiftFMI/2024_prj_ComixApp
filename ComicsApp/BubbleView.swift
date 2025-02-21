//
//  BubbleView.swift
//  ComicsApp
//
//  Created by Galya Dodova on 20.02.25.
//

import SwiftUI

struct BubbleView: View {
    @Binding var text: String
    @Binding var positionX: CGFloat
    @Binding var positionY: CGFloat
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
                .position(x:positionX, y:positionY)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.positionX = value.location.x
                            self.positionY = value.location.y
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
