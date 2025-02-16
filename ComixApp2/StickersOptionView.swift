import SwiftUI
import PhotosUI 

struct StickersOptionView: View {
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false
    @State var made1pic: Bool = false
    @Binding var stikercheta: [String]

    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 20)
            } else {
                Text("Няма избрана снимка")
            }

            HStack {
                if made1pic == false{
                    Button("Избери снимка oт галерия") {
                        isPickerPresented = true
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Button {
                        if let selectedImage = selectedImage {
                            let imageName = UUID().uuidString
                            stikercheta.append(imageName)
                            saveImageToDocumentsDirectory(image: selectedImage, imageName: imageName)
                            made1pic=true
                        }
                    } label: {
                        Text("Направи стикер")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))}
                else{
                    Text("Успешно добавихте стикера")
                }
            }
        }
        .sheet(isPresented: $isPickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }

    // Функция за запис на снимката в директорията на приложението
    func saveImageToDocumentsDirectory(image: UIImage, imageName: String) {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("\(imageName).jpg")
        
        do {
            try data.write(to: fileURL)
            print("Снимката е записана успешно в: \(fileURL)")
        } catch {
            print("Грешка при запис на снимката: \(error.localizedDescription)")
        }
    }
}
