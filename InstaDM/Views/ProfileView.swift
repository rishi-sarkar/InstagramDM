import SwiftUI

struct ProfileView: View {
    @StateObject private var updateProfileView = UpdateProfileView()  // ✅ Owns the instance
    @EnvironmentObject var userLogin: UserLogin  // ✅ Access global login state


    var body: some View {
        ZStack {
            SafariWebView(url: URL(string: "https://www.instagram.com/direct/inbox")!)
                .environmentObject(updateProfileView)
                .environmentObject(userLogin)

        }
    }
}
