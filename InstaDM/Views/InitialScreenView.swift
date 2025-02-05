import SwiftUI

struct InitialScreenView: View {
    @State private var isUserLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    
    var body: some View {
        if isUserLoggedIn {
            MainView() // ✅ Move to MainView if logged in
        } else {
            SafariWebView(url: URL(string: "https://www.instagram.com/direct/inbox")!, isUserLoggedIn: $isUserLoggedIn)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
