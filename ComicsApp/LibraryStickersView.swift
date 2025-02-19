//
//  LibraryStickersView.swift
//  ComicsApp
//
//  Created by Galya Dodova on 19.02.25.
//

import SwiftUI

struct LibraryStickersView: View {
  @State var stikercheta: [String] = [] // Масив със снимки (първоначално празен)
  let columns = 2
    var body: some View {
    VStack {
      HStack {
        if stikercheta.isEmpty {
          Text("Нямате добавени стикери/снимки")
            .font(.title2)
            .padding()
        } else {
          Text("Нападение с котки за щастие")
            .font(.title2)
            .padding()
        }
          NavigationLink {
          StickersOptionView(stikercheta: $stikercheta)
        } label: {
          Image(systemName: "plus.app.fill")
            .imageScale(.large)
        }
      }
        ScrollView {
        VStack {
            ForEach(stikercheta.reversed(), id: \.self) { imageName in
            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent("\(imageName).jpg")
              if let uiImage = UIImage(contentsOfFile: fileURL.path) {
              Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 100)
            }
          }
        }
        .padding()
      }
    }
  }
}
