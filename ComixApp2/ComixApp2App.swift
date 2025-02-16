import SwiftUI
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var storage: Storage!
    var db: Firestore!
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        // ✅ Initialize Firebase Storage
        storage = Storage.storage()
        
        // ✅ Initialize Firestore
        db = Firestore.firestore()
        
        // ✅ Create local folder if needed
        FirebaseStorageManager.shared.createImagesFolder()
        
        // ✅ Download all images from Firebase on app launch
        FirebaseStorageManager.shared.downloadAllImagesFromFirebase()
        
        print("✅ Firebase Storage and Firestore initialized successfully.")
        
        return true
    }

    // ✅ Upload images before the app quits
    func applicationWillTerminate(_ application: UIApplication) {
        FirebaseStorageManager.shared.uploadAllLocalImages()
    }
}

@main
struct ComixApp2App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
