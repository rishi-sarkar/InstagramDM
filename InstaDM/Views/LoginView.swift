import SwiftUI

struct LoginView: View {
    @State private var isLoggedIn: Bool = false

    var body: some View {
        SafariWebView(url: URL(string: "https://www.instagram.com/accounts/login")!)
            .edgesIgnoringSafeArea(.all)
    }
}
