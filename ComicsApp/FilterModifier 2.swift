import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct FilterModifier: ViewModifier {
    var filter: CIFilter
    var uiImage: UIImage
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                applyFilter()
            }
            .overlay {
                Image(uiImage: applyFilter()) // Apply the filter and update the UI
                    .resizable()
                    .scaledToFit()
            }
    }
    
    private func applyFilter() -> UIImage {
        // Convert UIImage to CIImage
        guard let ciImage = CIImage(image: uiImage) else {
            return uiImage
        }

        // Set the filter input (depending on the filter type)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        // Apply the filter and get the output CIImage
        guard let outputImage = filter.outputImage else {
            return uiImage
        }

        // Convert CIImage back to UIImage
        let context = CIContext()
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        return uiImage // return original image in case of failure
    }
}