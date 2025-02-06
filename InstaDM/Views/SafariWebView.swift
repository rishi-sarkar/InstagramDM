import SwiftUI
@preconcurrency import WebKit

struct SafariWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No update logic required.
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: SafariWebView

        init(_ parent: SafariWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let currentURL = navigationAction.request.url?.absoluteString {
                print("📢 Current URL: \(currentURL)")
                
                // ✅ Ignore `about:blank` and referer redirects
                if currentURL == "about:blank" || currentURL.contains("instagram.com/common/referer_frame.php") {
                    print("⚠️ Ignoring internal redirect: \(currentURL)")
                    decisionHandler(.cancel)
                    return
                }
                
                // Check if the URL contains the login endpoint.
                if currentURL.contains("instagram.com/accounts/login") {
                    // If the user was previously logged in, then they have been logged out mid-session.
                    if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
                        print("⚠️ User logged out mid-session. Redirecting to LoginView.")
                        NotificationCenter.default.post(name: .userDidLogout, object: nil)
                    }
                    decisionHandler(.allow)
                    return
                }
                
                if !currentURL.contains("/accounts"), !UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
                    NotificationCenter.default.post(name: .userDidLogin, object: nil)
                    decisionHandler(.cancel)
                    return
                }
                // ✅ Allow `facebook.com/instagram/login_sync` without redirecting
                if currentURL.contains("facebook.com/instagram/login_sync") {
                    print("🆗 Allowing Facebook login sync page")
                    decisionHandler(.allow)
                    return
                }

                // ✅ Redirect if not on `/direct/`
                if !currentURL.contains("instagram.com/direct/") {
                    print("🔄 Redirecting to Instagram Direct Inbox")
                    NotificationCenter.default.post(name: .userDidLogin, object: nil)
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }
    }
}
