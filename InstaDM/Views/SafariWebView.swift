import SwiftUI
@preconcurrency import WebKit

struct SafariWebView: UIViewRepresentable {
    let url: URL
    @Binding var isUserLoggedIn: Bool // ✅ Bind login status

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
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
                print("📢 Current URL: \(currentURL)") // ✅ Debugging

                // ✅ Check if redirected to login page (User is NOT logged in) and exit
                if currentURL.contains("instagram.com/accounts/login") {
                    print("❌ User is NOT logged in - Exiting Function")
                    DispatchQueue.main.async {
                        self.parent.isUserLoggedIn = false
                        UserDefaults.standard.set(false, forKey: "isUserLoggedIn") // ✅ Save login state
                    }
                    decisionHandler(.allow) // ✅ Allow navigation to login page
                    return // ✅ Exit function immediately (skip further checks)
                }
                else if (!self.parent.isUserLoggedIn) {
                    print("✅ User Logged In - Enabling Redirects")
                    DispatchQueue.main.async {
                        self.parent.isUserLoggedIn = true
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn") // ✅ Save login state
                        NotificationCenter.default.post(name: .userDidLogin, object: nil) // ✅ Notify InitialScreenView
                    }
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
                    webView.load(URLRequest(url: URL(string: "https://www.instagram.com/direct/inbox/")!))
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }
    }
}

// ✅ Notification Name for Login Event
extension Notification.Name {
    static let userDidLogin = Notification.Name("userDidLogin")
}
