import SwiftUI

struct MessagesView: View {
    @State private var userEscaped = false

    var body: some View {
            ZStack {
                SafariWebView(url: URL(string: "https://www.instagram.com/direct/inbox")!)
            }
            .onReceive(NotificationCenter.default.publisher(for: .userEscaped)) { _ in
                userEscaped = !userEscaped
            }
        }
}
