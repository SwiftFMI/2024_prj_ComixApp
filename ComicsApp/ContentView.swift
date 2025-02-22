//
//  ContentView.swift
//  ComicsApp
//
//  Created by Galya Dodova on 19.02.25.
//

import SwiftUI

struct ContentView: View {
  var size1: CGFloat = 150

    
    var body: some View {
    NavigationStack {
      VStack {
        RoundedRectangle(cornerRadius: 15)
          .fill(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.9), Color.indigo.opacity(1), Color.cyan]), startPoint: .topLeading, endPoint: .bottomLeading))
          .ignoresSafeArea().overlay(
            VStack{
              Text("ComixApp").foregroundColor(.white).font(.custom("COPPERPLATE", size: 50)).offset(y: -45)
              RoundedRectangle(cornerRadius: 15)
                .fill(.white)
                .frame(width: 300, height: 600)
                .ignoresSafeArea().overlay(
                    
                    VStack {
                    Image(systemName: "pencil.and.outline")
                      .imageScale(.large)
                      .foregroundStyle(.tint).padding(20)
                    
                    NavigationLink {
                      LibraryStickersView()
                    }
                        label: {
                      Text("Moite stikeri/snimki").foregroundColor(.teal).font(.system(size: 20))
                    }.padding()
                      .background(Color.clear)
                      .border(Color.teal, width: 4)
                      .clipShape(RoundedRectangle(cornerRadius: 8))
                      .padding(20)
                        
                    NavigationLink {
                      LibraryReadyComicsView()
                    } label: {
                      Text("Moite komiksi").foregroundColor(.teal).font(.system(size: 20))
                    }.padding()
                      .background(Color.clear)
                      .border(Color.teal, width: 4)
                      .clipShape(RoundedRectangle(cornerRadius: 8))
                    Spacer()
                        NavigationLink {
                        Text("Проектът е с учебна цел за курса Swift 2024/2025")
                        Text("(tuk tribvashe da slojim snimki, no niama vreme)")
                    } label: {
                      Image(systemName: "cat").foregroundColor(.gray.opacity(0.3))
                      Image(systemName: "cat").foregroundColor(.green)
                      Image(systemName: "cat").foregroundColor(.red)
                    }
                  }
                    .padding()).offset(y: -30)
            })
      }
    }
  }

    
}
#Preview {
  ContentView()
}
