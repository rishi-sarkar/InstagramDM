import SwiftUI
@preconcurrency import WebKit

struct SafariWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator

        // ✅ Load Instagram Direct only if the user is logged in
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            webView.load(URLRequest(url: url))
        }

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: SafariWebView

        init(_ parent: SafariWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let currentURL = navigationAction.request.url?.absoluteString {
                print("📢 Current URL: \(currentURL)")

                // ✅ Redirect only if user is logged in
                if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
                    if !currentURL.contains("instagram.com/direct/") {
                        print("🔄 Redirecting to Instagram Direct Inbox")
                        webView.load(URLRequest(url: URL(string: "https://www.instagram.com/direct/inbox/")!))
                        decisionHandler(.cancel)
                        return
                    }
                }
            }
            decisionHandler(.allow)
        }
    }
}
