import SwiftUI
@preconcurrency import WebKit

struct SafariWebView: UIViewRepresentable {
    let url: URL
    @Binding var postURL: URL? // ✅ Use IdentifiableURL wrapper

    
    func makeUIView(context: Context) -> WKWebView {
            let contentController = WKUserContentController()
            
            // Add JavaScript message handler
            contentController.add(context.coordinator, name: "urlChangeHandler")

            let config = WKWebViewConfiguration()
            config.userContentController = contentController
            // ✅ Prevent media auto-play (requires user interaction for playback)
            config.mediaTypesRequiringUserActionForPlayback = [.all]

            // ✅ Prevent videos from playing inline (forces fullscreen video)
            config.allowsInlineMediaPlayback = false

            let webView = WKWebView(frame: .zero, configuration: config)
            webView.navigationDelegate = context.coordinator
            context.coordinator.webView = webView // ✅ Assign webView reference to Coordinator

        
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
                print("🌍 Post URL: \(parent.postURL?.absoluteString ?? "N/A")")

                if let postURL = parent.postURL {
                    if (url.contains("/common") ||
                         url.contains("about:blank") ||
                         url.contains("instagram/login_sync"))
                    {}
                    else if !url.contains(postURL.absoluteString) {
                        if let webView = webView { // Ensure webView is available
                            webView.load(URLRequest(url: URL(string: postURL.absoluteString)!))
                            print("Redirected to designated post")
                        }
                    }
                }
                else {
                    if (url.contains("/direct") ||
                         url.contains("/accounts") ||
                         url.contains("/common") ||
                         url.contains("about:blank") ||
                         url.contains("paid_ads") ||
                         url.contains("instagram/login_sync") ||
                         url.contains("paid_ads"))
                    {}
                    else if url.contains("/p/") {
                        print("Post Redirect")
                        if let urlPost = URL(string: url) {
                            DispatchQueue.main.async {
                                self.parent.postURL = urlPost // ✅ Store post using wrapper
                            }
                        }
                    }
                    else {
                        if let webView = webView { // Ensure webView is available
                            webView.load(URLRequest(url: URL(string: "https://www.instagram.com/direct/inbox/")!))
                            print("Redirected to home page")
                        }
                    }
                }
            }
        }
    }
}

// ✅ Notification Name for Login Event
extension Notification.Name {
    static let userDidLogin = Notification.Name("userDidLogin")
}
