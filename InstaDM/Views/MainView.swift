import SwiftUI

struct MainView: View {
    @State private var showWebView = false

    var body: some View {
        ZStack {
            if showWebView {
                SafariWebView(url: URL(string: "https://www.instagram.com")!)
                    .edgesIgnoringSafeArea(.all)
            }

            // ✅ TabView stays on top
            TabView {
                MessagesView()
                    .tabItem {
                        Label("Messages", systemImage: "message.fill")
                    }

                RedirectedPostView()
                    .tabItem {
                        Label("Redirected Post", systemImage: "link")
                    }

                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
            }
        }
        .onAppear {
            checkLoginStatus()
        }
    }

    func checkLoginStatus() {
        if !UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            showWebView = true // ✅ Show WebView when not logged in
        }
    }
}
