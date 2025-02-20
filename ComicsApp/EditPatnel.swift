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
    
    @State private var selectedFilterName: String = "Sepia"
    @State private var selectedFilter: CIFilter = CIFilter.sepiaTone()
    @State private var filteredImage: UIImage?

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
                    appear2 ? .red.opacity(0.5) : .mint.opacity(0.5), appear2 ? .yellow.opacity(0.5) : .cyan.opacity(0.5),
                    .orange,
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
                                        Text("Sepia").tag("Sepia")
                                        Text("Monochrome").tag("Monochrome")
                                        Text("Invert").tag("Invert")
                                        Text("Vignette").tag("Vignette")
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(width: 250)
                                    .onChange(of: selectedFilterName) {
                                        updateFilter(for: $0)
                                        applyFilterToImage() // Приложи новия филтър
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
                        Image(uiImage: filteredImage ?? patern.getPhotos[0]) // Показване на филтрираното изображение или оригинала
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350 - CGFloat(ramkiWidth * 10), height: 350 - CGFloat(ramkiWidth * 10), alignment: .topLeading)
                            .clipped()
                    )
            }
        }
    }

    private func updateFilter(for filterName: String) {
        switch filterName {
        case "Sepia":
            selectedFilter = CIFilter.sepiaTone()
        case "Monochrome":
            selectedFilter = CIFilter.colorMonochrome()
        case "Invert":
            selectedFilter = CIFilter.colorInvert()
        case "Vignette":
            selectedFilter = CIFilter.vignette()
        default:
            selectedFilter = CIFilter.sepiaTone()
        }
    }
    
    private func applyFilterToImage() {
        guard let originalImage = patern.getPhotos.first else { return }
        
        // Приложи филтъра върху изображението
        filteredImage = applyFilter(uiImage: originalImage, filter: selectedFilter)
    }

    private func applyFilter(uiImage: UIImage, filter: CIFilter) -> UIImage? {
        guard let ciImage = CIImage(image: uiImage) else { return nil }
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        // Прилагане на филтъра
        guard let outputImage = filter.outputImage else {
            return uiImage // Ако не се получи резултат, връщаме оригиналното изображение
        }
        
        // Конвертиране на CIImage обратно в UIImage
        let context = CIContext()
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        return uiImage // В случай на грешка
    }
}
