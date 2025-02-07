import SwiftUI

struct RedirectedPostView: View {
    @State private var url: URL?
    @State private var showWebView = false
    @State private var isUserLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn") // ✅ Track login state
    @EnvironmentObject var userLogin: UserLogin  // ✅ Access global login state

    var body: some View {
        VStack {
            if let url = url {
                Button("Open Post") {
                    showWebView = true
                }
                .fullScreenCover(isPresented: $showWebView) {
                    SafariWebView(url: url) // ✅ Removed `isPresented`
                        .environmentObject(userLogin)

                }
            } else {
                Text("No post opened yet.")
                    .foregroundColor(.gray)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .newChatLink)) { notification in
            if let userInfo = notification.userInfo,
               let link = userInfo["link"] as? String,
               let validURL = URL(string: link) {
                self.url = validURL
                print("Updated URL: \(validURL)") // ✅ Debugging
            }
        }
    }
}
