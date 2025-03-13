import SwiftUI

struct InitialScreenView: View {
    @State private var postURL: URL?
    @State private var isWebViewLoaded = false // ✅ Lazy Load WebView

    var body: some View {
        ZStack {
            SafariWebView(
                url: URL(string: "https://www.instagram.com/direct/inbox")!,
                postURL: $postURL
            )
            if !isWebViewLoaded {
                Color(UIColor(red: 34/255, green: 40/255, blue: 47/255, alpha: 1)) // #22282f
                    .ignoresSafeArea()
                    .overlay(
                        Image("loading_screen")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150) // Adjust size as needed
                    )
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                            isWebViewLoaded = true // ✅ Delay WebView loading slightly
                        }
                    }
            }

            if let url = postURL {
                PostPopupView(url: url, postURL: $postURL) {
                    postURL = nil
                }
            }
        }
    }
}
