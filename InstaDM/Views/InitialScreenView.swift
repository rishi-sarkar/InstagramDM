import SwiftUI

struct InitialScreenView: View {
    @State private var isUserLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    @State private var showWebView = false

    var body: some View {
        if isUserLoggedIn {
            MainView() // ✅ Go to MainView if already logged in
        } else {
            VStack {
                Text("Checking login status...")
                    .onAppear {
                        checkLogin()
                    }
            }
            .overlay(
                // ✅ Show WebView when needed
                Group {
                    if showWebView {
                        SafariWebView(url: URL(string: "https://www.instagram.com")!)
                            .edgesIgnoringSafeArea(.all)
                    }
                }
            )
        }
    }

    func checkLogin() {
        AuthManager.shared.checkInstagramLogin { loggedIn in
            if loggedIn {
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                isUserLoggedIn = true
            } else {
                showWebView = true // ✅ Show WebView if not logged in
            }
        }
    }
}
