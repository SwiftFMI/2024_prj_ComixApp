import SwiftUI
class PhotoLayer{
    var originalPhoto: UIImage = UIImage()
    var filter: String = ""
    var zoom: Double = 0.0 // mai mojeshe s double za skale mejdu 0 i 1
    var rotate = 0//shte vidim imame li nujda ot tova
    
    init(filter: String, zoom: Double, rotate: Int = 0) {
        self.filter = filter
        self.zoom = zoom
        self.rotate = rotate
    }
    
}
