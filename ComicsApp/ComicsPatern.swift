//
//  ComicsPatern.swift
//  ComicsApp
//
//  Created by Galya Dodova on 19.02.25.
//

import SwiftUI
class ComicsPatern {
    var photoCount: Int = 0
    var photosOriginals: [UIImage] = []
    init(count: Int, originals: [UIImage]) {
        self.photoCount = count
        self.photosOriginals = originals
    }
    
    var getPhotos: [UIImage] {
        return photosOriginals
    }
}
