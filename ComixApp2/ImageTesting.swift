//
//  ImageTesting.swift
//  ComixApp2
//
//  Created by Galya Dodova on 16.02.25.
//

import SwiftUI

struct ImageTesting: View {
    @State private var uploadedImageURL: String?
    @State private var downloadedImage: UIImage?
    @State private var imageUrls: [String] = []
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Upload Image Button
            Button(action: uploadCat3Image) {
                Text("📤 Upload 'cat3' Image")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            // Show uploaded URL
            if let uploadedImageURL = uploadedImageURL {
                Text("Uploaded Image URL: \(uploadedImageURL)")
                    .foregroundColor(.blue)
                    .padding()
                    .onTapGesture {
                        downloadImage(from: uploadedImageURL)
                    }
            }
            
            // Downloaded Image Preview
            if let downloadedImage = downloadedImage {
                Image(uiImage: downloadedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)
            }
            
            // List All Images Button
            Button(action: listAllImages) {
                Text("📂 List All Images")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            // Show list of image URLs
            List(imageUrls, id: \.self) { url in
                Text(url)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        downloadImage(from: url)
                    }
            }
        }
        .padding()
    }
    
    // 📌 Upload "cat3" Image from Preview Content
    func uploadCat3Image() {
        guard let cat3Image = UIImage(named: "cat3") else {
            print("❌ Failed to load cat3 image from assets.")
            return
        }
        
        FirebaseStorageManager.shared.uploadImage(image: cat3Image) { url in
            if let url = url {
                uploadedImageURL = url
                print("✅ Uploaded 'cat3' Image URL: \(url)")
            } else {
                print("❌ Failed to upload 'cat3' image.")
            }
        }
    }
    
    // 📌 Download an Image
    func downloadImage(from url: String) {
        FirebaseStorageManager.shared.downloadImage(imageUrl: url) { image in
            if let image = image {
                downloadedImage = image
                print("✅ Image downloaded successfully")
            } else {
                print("❌ Failed to download image")
            }
        }
    }
    
    // 📌 List All Images
    func listAllImages() {
        FirebaseStorageManager.shared.listAllImages { urls in
            imageUrls = urls
            print("✅ Retrieved Image URLs: \(urls)")
        }
    }
}

#Preview {
    ImageTesting()
}
