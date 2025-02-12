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
        context.coordinator.webView = webView // ✅ Assign webView reference to Coordinator

        // ✅ Load Instagram DMs
        let request = URLRequest(url: url)
        webView.load(request)
        
        DispatchQueue.main.async {
            context.coordinator.injectJavaScript(into: webView)
        }
        

        return webView
    }



    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // ✅ Fix: Make Coordinator conform to WKScriptMessageHandler
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: SafariWebView
        weak var webView: WKWebView? // Add a weak reference to the WKWebView

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
                
                
                
//                if !(url.contains("/direct") ||
//                     url.contains("/accounts") ||
//                     url.contains("/common") ||
//                     url.contains("about:blank") ||
//                     url.contains("paid_ads") ||
//                     url.contains("instagram/login_sync") ||
//                     url.contains("paid_ads")) {
//                    
//                }
//                else if !url.contains("/direct") {
//                    if let webView = webView { // Ensure webView is available
//                        webView.load(URLRequest(url: URL(string: "https://www.instagram.com/direct/inbox/")!))
//                        print("Redirected bitch")
//                    }
//                }
//                else if !url.contains("/direct") {
//                    if let webView = webView { // Ensure webView is available
//                        webView.load(URLRequest(url: URL(string: "https://www.instagram.com/direct/inbox/")!))
//                        print("Redirected bitch")
//                    }
//                }
//                else if !url.contains("/direct") {
//                    if let webView = webView { // Ensure webView is available
//                        webView.load(URLRequest(url: URL(string: "https://www.instagram.com/direct/inbox/")!))
//                        print("Redirected bitch")
//                    }
//                }
//                else if !url.contains("/direct") {
//                    if let webView = webView { // Ensure webView is available
//                        webView.load(URLRequest(url: URL(string: "https://www.instagram.com/direct/inbox/")!))
//                        print("Redirected bitch")
//                    }
//                }
//                else if !url.contains("/direct") {
//                    if let webView = webView { // Ensure webView is available
//                        webView.load(URLRequest(url: URL(string: "https://www.instagram.com/direct/inbox/")!))
//                        print("Redirected bitch")
//                    }
//                }
//                
//                
//                
//                if !url.contains("/direct") {
//                    if let webView = webView { // Ensure webView is available
//                        webView.load(URLRequest(url: URL(string: "https://www.instagram.com/direct/inbox/")!))
//                        print("Redirected bitch")
//                    }
//                }
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
        // ✅ Ensure JavaScript reinjection after every page load
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("✅ Page Loaded: \(webView.url?.absoluteString ?? "Unknown")")
            DispatchQueue.main.async {
                self.injectJavaScript(into: webView) // Reinject JS every time the page loads
            }
        }
        
        // ✅ Function to inject JavaScript into the web page
        func injectJavaScript(into webView: WKWebView) {
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
            
            webView.evaluateJavaScript(jsScript, completionHandler: { (result, error) in
                if let error = error {
                    print("⚠️ JavaScript Injection Error: \(error.localizedDescription)")
                } else {
                    print("✅ JavaScript Injected Successfully")
                }
            })
        }
    }
}

// ✅ Notification Name for Login Event
extension Notification.Name {
    static let userDidLogin = Notification.Name("userDidLogin")
}
