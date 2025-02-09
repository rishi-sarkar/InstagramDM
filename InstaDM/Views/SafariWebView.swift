import SwiftUI
@preconcurrency import WebKit

struct SafariWebView: UIViewRepresentable {
    let url: URL
    @Binding var isUserLoggedIn: Bool // ✅ Bind login status

    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        
        // Add JavaScript message handler
        contentController.add(context.coordinator, name: "urlChangeHandler")

        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator

        // ✅ JavaScript to listen for URL changes due to button clicks
        let jsScript = """
        function sendUrlChange() {
            window.webkit.messageHandlers.urlChangeHandler.postMessage({ url: window.location.href });
        }
        
        // Detect URL changes using pushState, replaceState, and popstate
        (function(history) {
            let pushState = history.pushState;
            let replaceState = history.replaceState;
            
            history.pushState = function(state) {
                pushState.apply(history, arguments);
                sendUrlChange();
            };
            
            history.replaceState = function(state) {
                replaceState.apply(history, arguments);
                sendUrlChange();
            };
            
            window.addEventListener("popstate", sendUrlChange);
        })(window.history);

        // ✅ Detect button clicks inside Instagram DMs and send potential post URLs
        document.addEventListener("click", function(event) {
            let closestAnchor = event.target.closest("a");  // Find closest <a> element
            if (closestAnchor && closestAnchor.href.includes('/p/')) {
                window.webkit.messageHandlers.urlChangeHandler.postMessage({
                    url: closestAnchor.href,
                    type: "Post Click"
                });
            }
        });

        // Send initial page load URL
        sendUrlChange();
        """

        let userScript = WKUserScript(source: jsScript, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        contentController.addUserScript(userScript)

        webView.load(URLRequest(url: url))
        return webView
    }


    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // ✅ Fix: Make Coordinator conform to WKScriptMessageHandler
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: SafariWebView

        init(_ parent: SafariWebView) {
            self.parent = parent
        }

        // ✅ Handle JavaScript messages
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "urlChangeHandler", let messageBody = message.body as? [String: Any] {
                let url = messageBody["url"] as? String ?? "No URL"
                let type = messageBody["type"] as? String ?? "Navigation"

                print("📩 JavaScript Event: \(type)")
                print("🌍 Page URL: \(url)")
            }
        }
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url {
                print("🔗 Intercepted Navigation: \(url.absoluteString)")

                // Detect Instagram post URLs (e.g., https://www.instagram.com/p/POST_ID/)
                if url.absoluteString.contains("/p/") {
                    print("📌 Instagram Post Click Detected: \(url.absoluteString)")
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
