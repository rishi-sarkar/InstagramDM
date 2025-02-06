import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")

    var body: some View {
//        //initial logged in check
//        Task {
//            isLoggedIn = await AuthManager.shared.userShouldBeLoggedIn()
//        }
        NavigationView {
            if isLoggedIn {
                MainView() // Show MainView when logged in
            } else {
                LoginView() // Show LoginView when logged out
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .userDidLogin)) { _ in
            isLoggedIn = true
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        }
        .onReceive(NotificationCenter.default.publisher(for: .userDidLogout)) { _ in
            isLoggedIn = false
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        }
        
    }
}
