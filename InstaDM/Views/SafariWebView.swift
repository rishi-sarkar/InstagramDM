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

        // ✅ JavaScript to listen for URL changes
        let jsScript = """
        function sendUrlChange() {
            window.webkit.messageHandlers.urlChangeHandler.postMessage({ url: window.location.href });
        }
        
        // Detect URL changes with pushState, replaceState, and popstate
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

        // Handle JavaScript messages for URL changes
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "urlChangeHandler", let messageBody = message.body as? [String: Any] {
                if let url = messageBody["url"] as? String {
                    print("🌍 Page URL Changed: \(url)")
                }
            }
        }
    }
}

// ✅ Notification Name for Login Event
extension Notification.Name {
    static let userDidLogin = Notification.Name("userDidLogin")
}
