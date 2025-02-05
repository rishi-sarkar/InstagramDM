import WebKit

class AuthManager {
    static let shared = AuthManager()

    private init() {}

    func checkInstagramLogin(completion: @escaping (Bool) -> Void) {
        let websiteDataStore = WKWebsiteDataStore.default()
        websiteDataStore.httpCookieStore.getAllCookies { cookies in
            let isLoggedIn = cookies.contains { $0.domain.contains("instagram.com") }
            completion(isLoggedIn)
        }
    }
}
