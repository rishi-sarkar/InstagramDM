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

        // 1) Policy for navigation actions (already in your original code)
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            print("➡️ decidePolicyFor navigationAction: \(navigationAction.request.url?.absoluteString ?? "")")
            decisionHandler(.allow)
        }

        // 2) Policy for navigation responses
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationResponse: WKNavigationResponse,
                     decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            print("➡️ decidePolicyFor navigationResponse: \(navigationResponse.response.url?.absoluteString ?? "")")
            decisionHandler(.allow)
        }

        // 3) Called when navigation starts to load
        func webView(_ webView: WKWebView,
                     didStartProvisionalNavigation navigation: WKNavigation!) {
            print("🟢 didStartProvisionalNavigation: \(webView.url?.absoluteString ?? "N/A")")
        }

        // 4) Called when the first byte is received
        func webView(_ webView: WKWebView,
                     didCommit navigation: WKNavigation!) {
            print("🟢 didCommit navigation: \(webView.url?.absoluteString ?? "N/A")")
        }

        // 5) Called when navigation is complete
        func webView(_ webView: WKWebView,
                     didFinish navigation: WKNavigation!) {
            print("✅ didFinish navigation: \(webView.url?.absoluteString ?? "N/A")")
        }

        // 6) Called if navigation fails
        func webView(_ webView: WKWebView,
                     didFail navigation: WKNavigation!,
                     withError error: Error) {
            print("❌ didFail navigation: \(error.localizedDescription)")
        }

        // 7) Called if navigation fails while the provisional (initial) request is being processed
        func webView(_ webView: WKWebView,
                     didFailProvisionalNavigation navigation: WKNavigation!,
                     withError error: Error) {
            print("❌ didFailProvisionalNavigation: \(error.localizedDescription)")
        }

        // 8) Called when the web view receives a server redirect
        func webView(_ webView: WKWebView,
                     didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
            print("🔀 didReceiveServerRedirectForProvisionalNavigation")
        }
    }
}

// ✅ Notification Name for Login Event
extension Notification.Name {
    static let userDidLogin = Notification.Name("userDidLogin")
}
