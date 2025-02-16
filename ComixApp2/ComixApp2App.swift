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
        
        print("✅ Firebase Storage and Firestore initialized successfully.")
        
        return true
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

