import SwiftUI

struct MessagesView: View {
    @State private var showWebView = true
    @State private var isUserLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn") // ✅ Track login state

    var body: some View {
        VStack {
            // Your existing MessagesView UI (if any)
        }
        .onAppear {
            showWebView = true
        }
        .fullScreenCover(isPresented: $showWebView) {
            SafariWebView(url: URL(string: "https://www.instagram.com/direct/inbox")!, isUserLoggedIn: $isUserLoggedIn) // ✅ Pass isUserLoggedIn
        }
    }
}
