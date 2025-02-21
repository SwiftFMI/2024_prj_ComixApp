import SwiftUI
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins

  //Kodut za gradientite ot tuk:
  //https://www.youtube.com/watch?v=_lsnGyF2WZg

struct EditPatnel: View {
    var snimchici: [UIImage]
    var count: Int
    let patern: ComicsPatern
    
    @State var oformlenie: [[String]] = [
        ["По подразбиране"],
        ["Една до друга", "Една под друга"],
        ["Една до друга", "Една под друга", "Една горе и две долу", "Една долу и две горе", "Една вляво и две вдясно", "Една вдясно и две вляво"]
    ]
    
    @State var appear = false
    @State var appear2 = false
    @State var ramkiWidth: Int = 2
    @State var cviat: Color = .white
    
    @State private var selectedFilterName: String = "None"
    @State private var selectedFilter: CIFilter?
    @State private var filteredImage: UIImage?
    
    @State var scalePhoto: CGFloat = 1.0

    @State private var imageToEdit: Image

    init(snimchici: [UIImage], count: Int) {
        self.snimchici = snimchici
        self.count = count
        self.patern = ComicsPatern(count: count, originals: snimchici)
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
                    Text("Edit Panel")
                        .font(.largeTitle)
                        .foregroundStyle(.white).offset(y: -50)

                    NavigationLink {
                        EditBubbles(image: $imageToEdit)
                    }
                    label: {
                        Image(systemName:"bubble.circle").foregroundColor(.teal).font(.system(size: 20))
                    }
                    .padding()
                    .background(Color.clear)
                    .border(Color.teal, width: 4)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(20)

                   
                }
                if !patern.getPhotos.isEmpty {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white.opacity(0.5))
                        .frame(width: 350, height: 300)
                        .overlay(
                            VStack(alignment: .leading) {
                                HStack{
                                    if scalePhoto>0.4{
                                        Image(systemName: "minus.circle").font(.system(size: 40)).gesture(
                                            TapGesture().onEnded{ _ in scalePhoto -= 0.1}
                                        )
                                    }
                                    else{
                                        Image(systemName: "minus.circle").foregroundColor(.gray).font(.system(size: 40))
                                    }
                                    if scalePhoto<1.6{
                                        Image(systemName: "plus.circle").font(.system(size: 40)).gesture(
                                            TapGesture().onEnded{ _ in scalePhoto += 0.1}
                                        )
                                    }
                                    else{
                                        Image(systemName: "plus.circle").foregroundColor(.gray).font(.system(size: 40))
                                    }
                                }
                                HStack {
                                    Text("\(selectedFilterName)")
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
                                }
                                
                                HStack {
                                    Text("Дебелина рамка")
                                    Image(systemName: "text.line.first.and.arrowtriangle.forward")
                                    Spacer()
                                    Slider(
                                        value: Binding(
                                            get: { Double(ramkiWidth) },
                                            set: { ramkiWidth = Int($0) }
                                        ),
                                        in: 0...4,
                                        step: 1
                                    )
                                    Image(systemName: "paintpalette")
                                    ColorPicker("Цвят", selection: $cviat)
                                }
                                .padding(.horizontal)
                            }
                        )
                }
                
                Spacer()
                
                Rectangle()
                    .fill(cviat)
                    .frame(width: 350, height: 350)
                    .overlay(
                        Image(uiImage: filteredImage ?? patern.getPhotos[0])
                            .resizable()
                            .scaleEffect(scalePhoto)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350 - CGFloat(ramkiWidth * 10), height: 350 - CGFloat(ramkiWidth * 10))
                            .clipped()
                            .foregroundColor(.gray)
                                                )
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
}
