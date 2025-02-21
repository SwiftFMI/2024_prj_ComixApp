import SwiftUI
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins

  //Kodut za gradientite ot tuk:
  //https://www.youtube.com/watch?v=_lsnGyF2WZg

//kod za render
//https://www.hackingwithswift.com/quick-start/swiftui/how-to-convert-a-swiftui-view-to-an-image

class Bubble: Identifiable {
    let id = UUID()
    var text: String
    var positionX: Int = 0
    var positionY: Int = 0
    var scale: CGFloat
    
    init(text: String, positionX: Int, positionY: Int, scale: CGFloat) {
        self.text = text
        self.positionX = positionX
        self.positionY = positionY
        self.scale = scale
    }
}

struct EditPatnel: View {
    var snimchici: [UIImage]
    var count: Int
    let patern: ComicsPatern
    @State var zavursheni: [UIImage]
    
    @State var oformlenie: [[String]] = [
        ["По подразбиране"],
        ["Една до друга", "Една под друга"],
        ["Една до друга", "Една под друга", "Една горе и две долу", "Една долу и две горе", "Една вляво и две вдясно", "Една вдясно и две вляво"]
    ]
    
    @State var appear = false
    @State var appear2 = false
    @State var ramkiWidth: Int = 2
    @State var cviat: Color = .white
    @State var cviat2: Color = .red
    
    @State private var selectedFilterName: String = "None"
    @State private var selectedFilter: CIFilter?
    @State private var filteredImage: UIImage?
    
    @State var degreesRotation: Double = 0
    
    @State var scalePhoto: CGFloat = 1.0
    
    @State var bubbles: [Bubble] = []
    @State private var text: String = ""
    @State var positionX: CGFloat = 200
    @State var positionY: CGFloat = 300
    @State private var scale: CGFloat = 1.0
    @State var havingBubble: Bool = false
    @State var textRazmer: CGFloat = 16

    @State private var imageToEdit: Image
    @State private var renderedImage: Image = Image(systemName: "photo")
    @Environment(\.displayScale) var displayScale
    
    @State var creating: Bool

    init(snimchici: [UIImage], count: Int, zavursheni: [UIImage], creating: Bool) {
        self.snimchici = snimchici
        self.count = count
        self.patern = ComicsPatern(count: count, originals: snimchici)
        self.zavursheni = zavursheni
        self.creating = creating
        _imageToEdit = State(initialValue: Image(uiImage: snimchici.first ?? UIImage()))
    }

    var body: some View {
        ZStack {
                  MeshGradient(
                      width: 3, height: 3,
                      points: [
                          [0.0, 0.0], [appear2 ? 0.5 : 1.0, 0.0], [1.0, 0.0],
                          [0.0, 0.5], appear ? [0.1, 0.5] : [0.8, 0.2], [1.0, -0.5],
                          [0.0, 1.0], [1.0, appear2 ? 1.5 : 1.0], [1.0, 1.0]
                      ],
                      colors: [
                          appear2 ? .red.opacity(0.5) : .mint.opacity(0.5), appear2 ? .yellow.opacity(0.5) : .cyan.opacity(0.5),.orange,
                          appear ? .blue.opacity(0.5) : .red.opacity(0.5), appear ? .cyan.opacity(0.5) : .white.opacity(0.5), appear ? .red.opacity(0.5) : .purple.opacity(0.5),
                          appear ? .red.opacity(0.5): .cyan.opacity(0.5), appear ? .mint.opacity(0.5) : .blue.opacity(0.5), appear ? .red.opacity(0.5) : .blue.opacity(0.5)
                      ]
                  )
                  .ignoresSafeArea()
                  .onAppear {
                      withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                          appear.toggle()
                      }
                      withAnimation(.easeInOut(duration: 15).repeatForever(autoreverses: true)) {
                          appear2.toggle()
                      }
                  }
            VStack {
                HStack{
                    /*Text("Edit Panel")
                        .font(.largeTitle)
                        .foregroundStyle(.white).offset(y: -50)
                    */
                    
                    /*NavigationLink {
                        EditBubbles(bubbles: bubbles, image: imageToEdit)
                    }
                    label: {
                        Text("Добави балонче")
                    }
                    .padding()*/
                    

                    
                }
                .frame(width: 250)
                
                HStack {
                    Button(action: {
                        renderAndSaveImage()
                    }) {
                        Text("Запази в галерията")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    
                    ShareLink("Сподели", item: renderedImage, preview: SharePreview(Text("Споделена снимка"), image: renderedImage))
                    .padding()}
                
                
                Button("cLICK TO SAVE IMAGE") {
                    guard let image = ImageRenderer(content: specialen2).uiImage else { return }
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
                
                Button("Save to app comics") {
                    guard let image = ImageRenderer(content: specialen2).uiImage else {
                        print("ugh")
                        return
                    }

                    // Преобразуваме UIImage в Data
                    guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                        print("ugh")
                        return
                    }

                    let fileManager = FileManager.default
                    let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let imagePath = documentsDirectory.appendingPathComponent("comicImage.jpg")

                    do {
                        try imageData.write(to: imagePath)
                        print("Изображението беше успешно записано на път: \(imagePath)")
                    } catch {
                        print("Грешка при записване на изображението: \(error)")
                    }
                    
                    zavursheni.append(image)  // Appending UIImage instead of String
                    creating = false
                }
                
                if !patern.getPhotos.isEmpty {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white.opacity(0.5))
                        .frame(width: 350, height: 300)
                        .overlay(
                            VStack() {
                                HStack{
                                    Text("Балонче?")
                                    Image(systemName: "bubble.left").font(.system(size: 35)).gesture(
                                        TapGesture().onEnded{ _ in havingBubble=true}
                                    )
                                    if textRazmer>6{
                                        Image(systemName: "minus.circle").font(.system(size: 25)).gesture(
                                            TapGesture().onEnded{ _ in textRazmer -= 2}
                                        )
                                    }
                                    else{
                                        Image(systemName: "minus.circle").foregroundColor(.gray).font(.system(size: 25))
                                    }
                                    if scalePhoto<20{
                                        Image(systemName: "plus.circle").font(.system(size: 25)).gesture(
                                            TapGesture().onEnded{ _ in textRazmer += 2}
                                        )
                                    }
                                    else{
                                        Image(systemName: "plus.circle").foregroundColor(.gray).font(.system(size: 25))
                                    }
                                }
                                HStack{
                                    Text("Мащабиране")
                                    Image(systemName: "plus.slash.minus")
                                    if scalePhoto>0.4{
                                        Image(systemName: "minus.circle").font(.system(size: 35)).gesture(
                                            TapGesture().onEnded{ _ in scalePhoto -= 0.1}
                                        )
                                    }
                                    else{
                                        Image(systemName: "minus.circle").foregroundColor(.gray).font(.system(size: 35))
                                    }
                                    if scalePhoto<1.3{
                                        Image(systemName: "plus.circle").font(.system(size: 35)).gesture(
                                            TapGesture().onEnded{ _ in scalePhoto += 0.1}
                                        )
                                    }
                                    else{
                                        Image(systemName: "plus.circle").foregroundColor(.gray).font(.system(size: 35))
                                    }
                                    
                                    
                                    Image(systemName: "arrow.trianglehead.clockwise.rotate.90").font(.system(size: 35)).gesture(
                                        TapGesture().onEnded{ _ in degreesRotation -= 10}
                                    )
                                    
                                    Image(systemName: "arrow.trianglehead.counterclockwise.rotate.90").font(.system(size: 35)).gesture(
                                        TapGesture().onEnded{ _ in degreesRotation += 10}
                                    )
                                    
                                    
                                }.padding(.horizontal)
                                
                                HStack {
                                    Text("Филтър")
                                        .frame(width: 60).offset(x:20)
                                    Image(systemName: "photo.artframe.circle").font(.system(size: 25)).offset(x:20)
                                    Picker("Филтър", selection: $selectedFilterName) {
                                        Text("None").tag("None")
                                        Text("Sepia").tag("Sepia")
                                        Text("Monochrome").tag("Monochrome")
                                        Text("Invert").tag("Invert")
                                        Text("Vignette").tag("Vignette")
                                        Text("Comic").tag("Comic")
                                        Text("Crystallize").tag("Crystallize")
                                        Text("Pointillize").tag("Pointillize")
                                        Text("Bloom").tag("Bloom")
                                        Text("Gloom").tag("Gloom")
                                        Text("Pixellate").tag("Pixellate")
                                        Text("Thermal").tag("Thermal")
                                        Text("X-Ray").tag("X-Ray")
                                        Text("Posterize").tag("Posterize")
                                        Text("Dot Screen").tag("Dot Screen")
                                        Text("Line Overlay").tag("Line Overlay")
                                        Text("Gaussian Blur").tag("Gaussian Blur")
                                        Text("Sharpen").tag("Sharpen")
                                        Text("Edges").tag("Edges")
                                        Text("Hexagonal Pixellate").tag("Hexagonal Pixellate")
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(width: 250)
                                    .onChange(of: selectedFilterName) {
                                        updateFilter(for: $0)
                                        applyFilterToImage()
                                    }
                                }.padding(.horizontal)
                                
                                HStack {
                                    VStack{
                                        Text("Дебелина рамка")
                                        HStack{
                                            Image(systemName: "text.line.first.and.arrowtriangle.forward").offset(x:20)
                                            Spacer()
                                            Slider(
                                                value: Binding(
                                                    get: { Double(ramkiWidth) },
                                                    set: { ramkiWidth = Int($0) }
                                                ),
                                                in: 0...4,
                                                step: 1
                                            ).offset(x:20)
                                        }
                                    }
                                    
                                    VStack{
                                        HStack{
                                            Image(systemName: "paintpalette")
                                            Text("Цвят рамка")
                                        }
                                        HStack{
                                            ColorPicker("", selection: $cviat).offset(x:-20)
                                        }
                                    }
                                    
                                    VStack{
                                        HStack{
                                            Image(systemName: "paintpalette")
                                            Text("Цвят фoн")
                                        }
                                        HStack{
                                            ColorPicker("", selection: $cviat2).offset(x:-30)
                                        }
                                    }
                                    
                                }
                                
                            }
                            
                        )
                }
                
                Spacer()
                
                specialen2

                
            }
            

            
            
            
        }
        
    }

    private func updateFilter(for filterName: String) {
        switch filterName {
        case "None":
            selectedFilter = nil
        case "Sepia":
            selectedFilter = CIFilter.sepiaTone()
        case "Monochrome":
            selectedFilter = CIFilter.colorMonochrome()
        case "Invert":
            selectedFilter = CIFilter.colorInvert()
        case "Vignette":
            selectedFilter = CIFilter.vignette()
        case "Comic":
            selectedFilter = CIFilter.comicEffect()
        case "Crystallize":
            selectedFilter = CIFilter.crystallize()
        case "Pointillize":
            selectedFilter = CIFilter.pointillize()
        case "Bloom":
            selectedFilter = CIFilter.bloom()
        case "Gloom":
            selectedFilter = CIFilter.gloom()
        case "Pixellate":
            selectedFilter = CIFilter.pixellate()
        case "Thermal":
            selectedFilter = CIFilter.thermal()
        case "X-Ray":
            selectedFilter = CIFilter.xRay()
        case "Posterize":
            selectedFilter = CIFilter.colorPosterize()
        case "Dot Screen":
            selectedFilter = CIFilter.dotScreen()
        case "Line Overlay":
            selectedFilter = CIFilter.lineOverlay()
        case "Gaussian Blur":
            selectedFilter = CIFilter.gaussianBlur()
        case "Sharpen":
            selectedFilter = CIFilter.sharpenLuminance()
        case "Edges":
            selectedFilter = CIFilter.edges()
        case "Hexagonal Pixellate":
            selectedFilter = CIFilter.hexagonalPixellate()
        default:
            selectedFilter = nil
        }
    }
    
    @MainActor func renderAndSaveImage() {
        let imageView = createImageView()

        // Convert the SwiftUI view to a UIImage
        if let uiImage = convertSwiftUIViewToUIImage(view: AnyView(imageView)) {
            // If the conversion was successful, update the rendered image state
            renderedImage = Image(uiImage: uiImage)
            
            // Now save the image to the gallery
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
        } else {
            print("Failed to render image")
        }
    }
    
    func convertSwiftUIViewToUIImage(view: AnyView) -> UIImage? {
        let hostingController = UIHostingController(rootView: view)
        let viewSize = hostingController.view.intrinsicContentSize

        // Ensure we use the right size
        hostingController.view.frame = CGRect(origin: .zero, size: viewSize)
        let renderer = UIGraphicsImageRenderer(size: viewSize)

        let image = renderer.image { _ in
            hostingController.view.drawHierarchy(in: hostingController.view.bounds, afterScreenUpdates: true)
        }
        
        return image
    }

    func createImageView() -> some View {
        ZStack{
            
            VStack{
                Rectangle()
                    .fill(cviat)
                    .frame(width: 350, height: 350)
                    .overlay(
                        Rectangle().fill(cviat2).frame(width: 350 - CGFloat(ramkiWidth * 10), height: 350 - CGFloat(ramkiWidth * 10)).overlay(
                            Image(uiImage: filteredImage ?? patern.getPhotos[0])
                                .resizable()
                                .scaleEffect(scalePhoto)
                                .aspectRatio(contentMode: .fill)
                                .rotation3DEffect(.degrees(degreesRotation),axis: (x: 0.0, y: 0.0, z: 1.0))
                            //.rotation3DEffect(.degrees(degreesRotation),axis: (x: 1.0, y: 0.0, z: 0.0))
                                .frame(width: 350 - CGFloat(ramkiWidth * 10), height: 350 - CGFloat(ramkiWidth * 10))
                                .clipped()
                        )
                    )
            }.position(x: UIScreen.main.bounds.width/2,y:200)
            
            if havingBubble{
                VStack{
                    SpeechBubble()
                        .fill(Color.white)
                        .frame(width: max(120, getTextWidth() * scale), height: max(70, getTextHeight() * scale))
                    //.frame(width: text.size(withAttributes: [.font: UIFont.preferredFont(forTextStyle: textRazmer)]).width + 40, height: max(70, getTextHeight() * scale))
                        .overlay(
                            TextField("(реплика)...", text: $text)
                                .font(.system(size: textRazmer))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .padding()
                                .frame(width: max(150, getTextWidth() * scale))
                        )
                        .shadow(radius: 5)
                        .position(x: positionX, y: positionY)
                    
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
                }.position(x: UIScreen.main.bounds.width/2,y:100)
                
            }
        }
    }
    
    private func applyFilterToImage() {
        guard let originalImage = patern.getPhotos.first else { return }
        
        if let filter = selectedFilter {
            filteredImage = applyFilter(uiImage: originalImage, filter: filter)
        } else {
            filteredImage = originalImage
        }
    }

    private func applyFilter(uiImage: UIImage, filter: CIFilter) -> UIImage? {
        guard let ciImage = CIImage(image: uiImage) else { return nil }
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputImage = filter.outputImage else {
            return uiImage
        }
        
        let context = CIContext()
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        return uiImage
    }
    
    private func getTextWidth() -> CGFloat {
            return text.size(withAttributes: [.font: UIFont.systemFont(ofSize: textRazmer)]).width+40
        }

    private func getTextHeight() -> CGFloat {
        return text.size(withAttributes: [.font: UIFont.systemFont(ofSize: textRazmer)]).height
    }
    
    var specialen2: some View{
        ZStack{
            
            VStack{
                Rectangle()
                    .fill(cviat)
                    .frame(width: 350, height: 350)
                    .overlay(
                        Rectangle().fill(cviat2).frame(width: 350 - CGFloat(ramkiWidth * 10), height: 350 - CGFloat(ramkiWidth * 10)).overlay(
                            Image(uiImage: filteredImage ?? patern.getPhotos[0])
                                .resizable()
                                .scaleEffect(scalePhoto)
                                .aspectRatio(contentMode: .fill)
                                .rotation3DEffect(.degrees(degreesRotation),axis: (x: 0.0, y: 0.0, z: 1.0))
                            //.rotation3DEffect(.degrees(degreesRotation),axis: (x: 1.0, y: 0.0, z: 0.0))
                                .frame(width: 350 - CGFloat(ramkiWidth * 10), height: 350 - CGFloat(ramkiWidth * 10))
                                .clipped()
                        )
                    )
            }.position(x: UIScreen.main.bounds.width/2,y:200)
            
            if havingBubble{
                VStack{
                    SpeechBubble()
                        .fill(Color.white)
                        .frame(width: max(120, getTextWidth() * scale), height: max(70, getTextHeight() * scale))
                    //.frame(width: text.size(withAttributes: [.font: UIFont.preferredFont(forTextStyle: textRazmer)]).width + 40, height: max(70, getTextHeight() * scale))
                        .overlay(
                            TextField("(реплика)...", text: $text)
                                .font(.system(size: textRazmer))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .padding()
                                .frame(width: max(150, getTextWidth() * scale))
                        )
                        .shadow(radius: 5)
                        .position(x: positionX, y: positionY)
                    
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
                }.position(x: UIScreen.main.bounds.width/2,y:100)
                
            }
        }
    }
}
