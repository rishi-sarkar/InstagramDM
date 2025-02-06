import SwiftUI

struct MessagesView: View {
    @State private var showWebView = true
    @State private var isUserLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn") // ✅ Track login state

    var body: some View {
        ZStack {
            SafariWebView(url: URL(string: "https://www.instagram.com/direct/inbox")!, isUserLoggedIn: $isUserLoggedIn)
        }
    }
}
