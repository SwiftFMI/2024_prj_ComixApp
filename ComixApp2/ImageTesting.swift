import SwiftUI

struct ImageTesting: View {
    @State private var localImages: [UIImage] = []

    var body: some View {
        VStack(spacing: 20) {
            
            // Upload All Images Button
            Button(action: uploadAllImages) {
                Text("📤 Upload All Images")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            // List of Local Images
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(localImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                    }
                }
            }
            
            // Download All Images Button
            Button(action: fetchImagesFromFirebase) {
                Text("📂 Download All Images")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .onAppear {
            FirebaseStorageManager.shared.createImagesFolder()
            loadLocalImages()
            fetchImagesFromFirebase()
        }
    }
    
    // 📌 Load Local Images into Array
    func loadLocalImages() {
        let fileManager = FileManager.default
        let folderPath = FirebaseStorageManager.shared.getImagesFolderPath()

        do {
            let files = try fileManager.contentsOfDirectory(at: folderPath, includingPropertiesForKeys: nil)
            localImages = files.compactMap { UIImage(contentsOfFile: $0.path) }
            print("✅ Loaded \(localImages.count) images from local storage")
        } catch {
            print("❌ Failed to load images: \(error.localizedDescription)")
        }
    }

    // 📌 Fetch Images from Firebase
    func fetchImagesFromFirebase() {
        FirebaseStorageManager.shared.downloadAllImagesFromFirebase()

        let images = FirebaseStorageManager.shared.getDownloadedImages()
        print("✅ Loaded \(images.count) images from Firebase")
    }

    // 📌 Upload All Local Images to Firebase
    func uploadAllImages() {
        FirebaseStorageManager.shared.uploadAllLocalImages()
    }
}

#Preview {
    ImageTesting()
}
