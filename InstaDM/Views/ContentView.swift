import SwiftUI

struct ContentView: View {
    @StateObject private var userLogin = UserLogin()

    var body: some View {
//        //initial logged in check
//        Task {
//            isLoggedIn = await AuthManager.shared.userShouldBeLoggedIn()
//        }
        NavigationView {
            if self.userLogin.isUserLoggedIn {
                MainView() // Show MainView when logged in
            } else {
                LoginView() // Show LoginView when logged out
                    .environmentObject(userLogin)
            }
        }
        
    }
}
