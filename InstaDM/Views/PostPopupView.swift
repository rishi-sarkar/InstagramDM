import SwiftUI
import WebKit

struct PostPopupView: View {
    let url: URL
    let postURL: Binding<URL?>
    var onDismiss: () -> Void // ✅ Callback to close popup

    var body: some View {
        ZStack {
            // ✅ Blurred Background
            VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { onDismiss() } // ✅ Close popup when tapping outside

            // ✅ Centered Rectangular Popup
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.clear.opacity(0.2                                                                                                                     )) // ✅ Dark semi-transparent background
                .frame(width: UIScreen.main.bounds.width * 0.85, // ✅ 80% of screen width
                       height: UIScreen.main.bounds.height * 0.85) // ✅ 60% of screen height
                .overlay(
                    SafariWebView(
                        url: url,
                        postURL: postURL
                    )                        .clipShape(RoundedRectangle(cornerRadius: 25))
                )
        }
    }
}

// ✅ Load the Post in a WebView inside the Popup
struct SafariPopupWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

// ✅ Helper View for Blurred Background
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
