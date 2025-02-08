import SwiftUI
@preconcurrency import WebKit

struct SafariWebView: UIViewRepresentable {
    let url: URL
    let caller: String
    
    @EnvironmentObject var userLogin: UserLogin  // ✅ Access global login state
    @EnvironmentObject var updateMessageView: UpdateMessageView  // ✅ Access global login state
    @EnvironmentObject var updateRedirectView: UpdateRedirectView  // ✅ Access global login state
    @EnvironmentObject var updateProfileView: UpdateProfileView  // ✅ Access global login state

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
                
//                // ✅ Ignore `about:blank` and referer redirects
//                if currentURL == "about:blank" ||      currentURL.contains("instagram.com/common/referer_frame.php") {
//                    print("⚠️ Ignoring internal redirect: \(currentURL)")
//                    decisionHandler(.cancel)
//                    return
//                }
                // ✅ Allow `facebook.com/instagram/login_sync` without redirecting
                if currentURL.contains("facebook.com/instagram/login_sync") {
                    print("🆗 Allowing Facebook login sync page")
                    decisionHandler(.allow)
                    return
                }
                // Check if the URL contains the login endpoint.
                if currentURL.contains("instagram.com/accounts/login") {
                    if self.parent.userLogin.isUserLoggedIn {
                        DispatchQueue.main.async {
                            print("⚠️ User logged out mid-session. Redirecting to LoginView.")
                            self.parent.userLogin.isUserLoggedIn = false
                        }
                    }
                    decisionHandler(.allow)
                    return
                }
                else if !self.parent.userLogin.isUserLoggedIn {
                    self.parent.userLogin.isUserLoggedIn = true
                    decisionHandler(.allow)
                    return
                }
                
                if self.parent.caller == "Profile" {
                    if currentURL == "about:blank" ||      currentURL.contains("instagram.com/common/referer_frame.php") {
                        print("⚠️ Ignoring internal redirect: \(currentURL)")
                        webView.load(URLRequest(url: URL(string: "https://www.instagram.com/rishi.sarkar")!))
                        self.parent.updateProfileView.updateProfileView = !self.parent.updateProfileView.updateProfileView
                        decisionHandler(.cancel)
                        return
                    }
                    // ✅ Redirect if not on `/direct/`
                    if !currentURL.contains("instagram.com/rishi.sarkar") {
                        print("🔄 Redirecting to Profile")
                        webView.load(URLRequest(url: URL(string: "https://www.instagram.com/rishi.sarkar")!))
                        self.parent.updateProfileView.updateProfileView = !self.parent.updateProfileView.updateProfileView
                        decisionHandler(.cancel)
                        return
                    }
                }
                if self.parent.caller == "Messages" {
                    // ✅ Redirect if not on `/direct/`
                    if !currentURL.contains("instagram.com/direct/") {
                        print("🔄 Redirecting to Instagram Direct Inbox")
                        webView.load(URLRequest(url: URL(string: "https://www.instagram.com/direct/inbox/")!))
                        self.parent.updateMessageView.updateMessageView = !self.parent.updateMessageView.updateMessageView
                        decisionHandler(.cancel)
                        return
                    }
                }

            }
            decisionHandler(.allow)
        }
    }
}
