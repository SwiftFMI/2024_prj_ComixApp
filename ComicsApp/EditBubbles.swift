//
//  EditBubbles.swift
//  ComicsApp
//
//  Created by Galya Dodova on 20.02.25.
//

import SwiftUI

struct EditBubbles: View {
    @State var bubbles: [Bubble]
    @State private var text: String = ""
    @State private var position: CGPoint = CGPoint(x: 200, y: 300) // Starting position of the bubble
    @State private var scale: CGFloat = 1.0

    @State var image: Image

    var body: some View {
        ZStack {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
                .clipped()

            //BubbleView(text: $text, positionX: position.x, positionY: position.y,scale: $scale)
                .zIndex(1)
        }
        .gesture(
            TapGesture()
                .onEnded {
                    self.text = "New Bubble"
                    self.position = CGPoint(x: 150, y: 150)
                    self.scale = 1.0
                }
        )
        .padding()
        
        Button{
            
        }label:
        {
            Text("Dobavi baloncheto")
        }
    }
}

