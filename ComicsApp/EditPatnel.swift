import SwiftUI
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct EditPatnel: View {
    var snimchici: [UIImage]
    var count: Int
    let patern: ComicsPatern
    
    init(snimchici: [UIImage], count: Int) {
        self.snimchici = snimchici
        self.count = count
        self.patern = ComicsPatern(count: count, originals: snimchici)
    }

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

    var body: some View {
        ZStack {
            VStack {
                Text("Edit Panel")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                
                if !patern.getPhotos.isEmpty {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white.opacity(0.5))
                        .frame(width: 350, height: 100)
                        .overlay(
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("\(selectedFilterName)")
                                    Picker("Филтър", selection: $selectedFilterName) {
                                        Text("None").tag("None") // Default
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
                                        applyFilterToImage() // Apply filter
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
                
                Rectangle()
                    .fill(cviat)
                    .frame(width: 350, height: 350)
                    .overlay(
                        Image(uiImage: filteredImage ?? patern.getPhotos[0])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350 - CGFloat(ramkiWidth * 10), height: 350 - CGFloat(ramkiWidth * 10))
                            .clipped()
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
