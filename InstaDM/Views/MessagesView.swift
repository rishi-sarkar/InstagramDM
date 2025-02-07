import SwiftUI

struct MessagesView: View {
    @StateObject private var updateMessageView = UpdateMessageView()  // ✅ Owns the instance
    @EnvironmentObject var userLogin: UserLogin  // ✅ Access global login state


    var body: some View {
        ZStack {
            SafariWebView(url: URL(string: "https://www.instagram.com/direct/inbox")!)
                .environmentObject(updateMessageView)
                .environmentObject(userLogin)
        }
    }
}
