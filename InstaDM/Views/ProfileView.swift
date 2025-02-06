import SwiftUI

struct ProfileView: View {
    @StateObject private var updateProfileView = UpdateProfileView()  // ✅ Owns the instance


    var body: some View {
        ZStack {
            SafariWebView(url: URL(string: "https://www.instagram.com/direct/inbox")!)
                .environmentObject(updateProfileView)
        }
    }
}
