import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct FilterModifier: ViewModifier {
    var filter: CIFilter
    var uiImage: UIImage
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                // Приложи филтъра върху изображението и го запази
                let filteredImage = applyFilter()
                content // Показва филтрираното изображение
                    .overlay(
                        Image(uiImage: filteredImage) // Използваме обработеното изображение
                            .resizable()
                            .scaledToFit()
                    )
            }
    }
    
    private func applyFilter() -> UIImage {
        guard let ciImage = CIImage(image: uiImage) else { return uiImage }
        
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
