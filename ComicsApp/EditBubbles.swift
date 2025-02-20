//
//  EditBubbles.swift
//  ComicsApp
//
//  Created by Galya Dodova on 20.02.25.
//

import SwiftUI

struct EditBubbles: View {
    @State private var text: String = ""
    @State private var position: CGPoint = CGPoint(x: 100, y: 100) // Starting position of the bubble
    @State private var scale: CGFloat = 1.0

    @Binding var image: Image // The image on which the bubble will be added

    var body: some View {
        ZStack {
            image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()

            BubbleView(text: $text, position: $position, scale: $scale)
                .zIndex(1) // Ensures the bubble is above the image
        }
        .gesture(
            TapGesture()
                .onEnded {
                    // Reset bubble properties or enable editing here if needed
                    // For example, resetting text and position
                    self.text = "New Bubble"
                    self.position = CGPoint(x: 150, y: 150)
                    self.scale = 1.0
                }
        )
        .padding()
    }
}

