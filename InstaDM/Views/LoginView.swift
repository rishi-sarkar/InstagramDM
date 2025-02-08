import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userLogin: UserLogin  // ✅ Access global login state
    
    var body: some View {
        SafariWebView(url: URL(string: "https://www.instagram.com/accounts/login")!, caller: "Login")
            .edgesIgnoringSafeArea(.all)
            .environmentObject(userLogin)
    }
}
