//
//  FirebaseStorageManager.swift
//  ComixApp2
//
//  Created by Galya Dodova on 16.02.25.
//
import UIKit
import FirebaseStorage

class FirebaseStorageManager {
    
    static let shared = FirebaseStorageManager() // Singleton instance
    private let storageRef = Storage.storage().reference().child("images/")

    // 📌 Function to Upload Image
    func uploadImage(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("❌ Failed to convert image to data")
            completion(nil)
            return
        }

        let imageRef = storageRef.child("\(UUID().uuidString).jpg")

        // Add metadata to indicate it's a JPEG image
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("❌ Upload failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            // Retrieve the download URL
            imageRef.downloadURL { (url, error) in
                DispatchQueue.main.async {
                    if let downloadURL = url?.absoluteString {
                        print("✅ Image uploaded successfully: \(downloadURL)")
                        completion(downloadURL)
                    } else {
                        print("❌ Failed to get download URL")
                        completion(nil)
                    }
                }
            }
        }
    }


    // 📌 Function to Download an Image
    func downloadImage(imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: imageUrl)
        URLSession.shared.dataTask(with: url!) { data, _, error in
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

    // 📌 Function to List All Images
    func listAllImages(completion: @escaping ([String]) -> Void) {
        storageRef.listAll { (result, error) in
            if let error = error {
                print("❌ Error listing images: \(error.localizedDescription)")
                completion([])
                return
            }

            // ✅ Safely unwrap result.items
            guard let items = result?.items else {
                print("❌ No items found")
                completion([])
                return
            }

            var imageUrls: [String] = []
            let dispatchGroup = DispatchGroup()

            for item in items {
                dispatchGroup.enter()
                item.downloadURL { (url, error) in
                    if let url = url {
                        imageUrls.append(url.absoluteString)
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                completion(imageUrls)
            }
        }
    }

}

