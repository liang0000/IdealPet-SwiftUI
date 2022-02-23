import SwiftUI
import Firebase

@main
struct IdealPetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var vm = AccountViewModelImpl(service: AccountServiceImpl())
    
    
    var body: some Scene {
        WindowGroup {
                switch vm.accState {
                case .loggedIn:
                    MasterScreen()
                        .environmentObject(vm)
                case .loggedOut:
                    LogInScreen()
                }
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
