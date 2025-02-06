//import WebKit
//
//class AuthManager {
//    static let shared = AuthManager()
//
//    private init() {}
//
//    func checkInstagramLogin(completion: @escaping (Bool) -> Void) {
//        let websiteDataStore = WKWebsiteDataStore.default()
//        websiteDataStore.httpCookieStore.getAllCookies { cookies in
//            print("🍪 Retrieved Cookies: \(cookies)") // Debugging
//            let isLoggedIn = cookies.contains { $0.domain.contains("instagram.com") }
//            print("✅ Login Status: \(isLoggedIn)") // Debugging
//            completion(isLoggedIn)
//        }
//    }
//}
