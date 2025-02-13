import SwiftUI

struct InitialScreenView: View {
    @State private var postURL: URL? // ✅ Use URL? instead of IdentifiableURL

    var body: some View {
        ZStack {
            SafariWebView(
                url: URL(string: "https://www.instagram.com/direct/inbox")!,
                postURL: $postURL // ✅ Pass URL binding
            )
            // ✅ Show custom popup when postURL is set
            if let url = postURL {
                PostPopupView(url: url, postURL: $postURL) {
                    postURL = nil // ✅ Close when tapping outside
                }
            }
        }
    }
}
