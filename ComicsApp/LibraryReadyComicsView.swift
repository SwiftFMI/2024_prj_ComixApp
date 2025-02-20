import SwiftUI
import PhotosUI

struct LibraryReadyComicsView: View {
    @State var zavursheni: [String] = []
    @State var creating: Bool = false
    @State var countSnimki = 1
    @State var snimki: [PhotosPickerItem] = []
    @State var selectedImages: [UIImage] = []
    
    @State var oformlenie: [[String]] = [
        ["По подразбиране"],
        ["Една до друга", "Една под друга"],
        ["Една до друга", "Една под друга", "Една горе и две долу", "Една долу и две горе", "Една вляво и две вдясно", "Една вдясно и две вляво"]
    ]
    
    @State var variantSnimki: Int = 0
    
    
    var body: some View {
        
        VStack {
            if creating {
                VStack {
                    HStack {
                        Text("\(countSnimki) броя снимки")
                            .font(.headline)
                        
                        Slider(
                            value: Binding(
                                get: { Double(countSnimki) },
                                set: { countSnimki = Int($0) }
                            ),
                            in: 1...3,
                            step: 1
                        )
                        .frame(width: 150)
                    }
                    
                    if countSnimki <= 3 {
                        Picker("Оформление на снимките", selection: $variantSnimki) {
                            ForEach(oformlenie[countSnimki - 1].indices, id: \.self) { index in
                                Text(oformlenie[countSnimki - 1][index]).tag(index)
                            }
                        }
                        .padding()
                        
                        Text("Избран вариант: \(oformlenie[countSnimki - 1][variantSnimki])")
                            .font(.headline)
                            .padding()
                    }
                    
                    if snimki.count == countSnimki {
                        HStack {
                            let screenWidth = UIScreen.main.bounds.width * 0.9
                            let imageWidth = screenWidth / CGFloat(snimki.count)
                            
                            ForEach(selectedImages, id: \.self) { uiImage in
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: imageWidth)
                                
                            }
                        }
                        .frame(height: 200)
                        .padding(.bottom, 10)
                    }
                    
                    PhotosPicker(
                        selection: $snimki,
                        maxSelectionCount: countSnimki,
                        matching: .images) {
                            HStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                Text("Изберете снимки")
                            }
                        }
                        .onChange(of: snimki) {
                            selectedImages.removeAll()
                            for item in snimki {
                                item.loadTransferable(type: Data.self) { result in
                                    switch result {
                                    case .success(let data):
                                        if let data = data, let uiImage = UIImage(data: data) {
                                            selectedImages.append(uiImage)
                                        }
                                    case .failure:
                                        print("Грешка при зареждане на снимка")
                                    }
                                }
                            }
                        }
                    
                    //Text("Избрани снимки: \(snimki.count)").font(.subheadline)
                    
                    if snimki.count == countSnimki {
                        NavigationLink {
                            EditPatnel(snimchici: selectedImages, count: countSnimki)
                        } label: {
                            Text("Към редактиране на панела")
                        }.padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            
            if !creating {
                HStack {
                    if zavursheni.isEmpty {
                        Text("Нямате завършени комикси")
                            .font(.title2)
                    } else {
                        Text("Завършените Ви комикси")
                            .font(.title2)
                    }
                    
                    Button {
                        creating = true
                    } label: {
                        Image(systemName: "plus.app.fill")
                            .imageScale(.large)
                    }
                }
                
                ScrollView {
                    VStack {
                        ForEach(zavursheni, id: \.self) { imageName in
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
                }
            }
        }
    }
}
