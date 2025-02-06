//import Foundation
//
//class AuthManager {
//    static let shared = AuthManager()
//    
//    /// Performs a background HTTP GET request to Instagram's login URL.
//    /// Returns `true` if the final URL does NOT contain "/accounts/login", otherwise `false`.
//    func userShouldBeLoggedIn() async -> Bool {
//        guard let url = URL(string: "https://www.instagram.com/accounts/login") else {
//            return false
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.timeoutInterval = 5  // Adjust as needed
//        
//        do {
//            let (_, response) = try await URLSession.shared.data(for: request)
//            
//            guard let httpResponse = response as? HTTPURLResponse,
//                  let finalURL = httpResponse.url else {
//                return false
//            }
//            
//            // If the final URL does not contain "/accounts/login", assume the user is logged in.
//            return !finalURL.absoluteString.contains("/accounts/login")
//            
//        } catch {
//            print("Error checking login status: \(error.localizedDescription)")
//            return false
//        }
//    }
//}
