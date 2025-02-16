//
//  HmView.swift
//  upr4marti
//
//  Created by Alexander Todorov on 11/29/24.
//
import SwiftUI

struct HmView: View {
    var body: some View {
        VStack {
            Image(systemName: "cat")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Napadenie s kotki za shtastie")
            ScrollView{
                VStack{
                    ForEach(1...100, id: \.self) { _ in
                        HStack{
                            ForEach(1...10, id: \.self) { _ in
                                Image(systemName: "cat")
                            }
                        }
                    }
                }
            }}
        .padding()
    }
}
