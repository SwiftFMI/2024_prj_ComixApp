import UIKit
import FirebaseStorage

class FirebaseStorageManager {
    
    static let shared = FirebaseStorageManager()
    private let storageRef = Storage.storage().reference().child("images/")
    private var localImages: [UIImage] = []  // 🔹 Store images for easy access in SwiftUI

    // 📌 Get Local Images Folder Path
    func getImagesFolderPath() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("images", isDirectory: true)
    }
    
    // 📌 Ensure the "images" folder exists
    func createImagesFolder() {
        let fileManager = FileManager.default
        let folderPath = getImagesFolderPath()

        if !fileManager.fileExists(atPath: folderPath.path) {
            do {
                try fileManager.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
                print("✅ Created 'images' folder at: \(folderPath.path)")
            } catch {
                print("❌ Failed to create 'images' folder: \(error.localizedDescription)")
            }
        } else {
            print("📂 'images' folder already exists")
        }
    }

    // 📌 Upload Image to Firebase
    func uploadImage(image: UIImage, name: String, completion: @escaping (Bool) -> Void) {
        guard let imageData = image.pngData() else {
            print("❌ Failed to get PNG data for \(name)")
            completion(false)
            return
        }

        let imageRef = storageRef.child(name)
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"

        imageRef.putData(imageData, metadata: metadata) { (_, error) in
            if let error = error {
                print("❌ Upload failed: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ Uploaded image: \(name)")
                completion(true)
            }
        }
    }

    // 📌 Upload All Local Images Before the App Closes
    func uploadAllLocalImages() {
        let fileManager = FileManager.default
        let folderPath = getImagesFolderPath()

        do {
            let files = try fileManager.contentsOfDirectory(at: folderPath, includingPropertiesForKeys: nil)
            let dispatchGroup = DispatchGroup()

            for file in files {
                dispatchGroup.enter()
                if let image = UIImage(contentsOfFile: file.path) {
                    uploadImage(image: image, name: file.lastPathComponent) { _ in
                        dispatchGroup.leave()
                    }
                } else {
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                print("✅ Finished uploading all local images")
            }
        } catch {
            print("❌ Failed to read local images: \(error.localizedDescription)")
        }
    }

    // 📌 Download Image from Firebase
    func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {
            print("❌ Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                print("❌ Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }.resume()
    }

    // 📌 Download All Images from Firebase and Save Locally
    func downloadAllImagesFromFirebase() {
        storageRef.listAll { (result, error) in
            if let error = error {
                print("❌ Error listing images: \(error.localizedDescription)")
                return
            }
            
            guard let result = result else {
                print("❌ No images found in Firebase")
                return
            }

            let dispatchGroup = DispatchGroup()
            var downloadedImages: [UIImage] = []

            for item in result.items {
                dispatchGroup.enter()
                item.downloadURL { (url, error) in
                    if let url = url {
                        self.downloadImage(from: url.absoluteString) { image in
                            if let image = image {
                                downloadedImages.append(image)
                                self.saveImageLocally(image: image, name: item.name)
                            }
                            dispatchGroup.leave()
                        }
                    } else {
                        dispatchGroup.leave()
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.localImages = downloadedImages
                print("✅ Downloaded and stored \(downloadedImages.count) images locally.")
            }
        }
    }

    // 📌 Save Image to Local Storage
    func saveImageLocally(image: UIImage, name: String) {
        let fileURL = getImagesFolderPath().appendingPathComponent(name)

        if let imageData = image.pngData() {
            try? imageData.write(to: fileURL)
            print("✅ Image saved locally: \(fileURL.path)")
        }
    }

    // 📌 Get All Downloaded Images as Array
    func getDownloadedImages() -> [UIImage] {
        return localImages
    }
}
