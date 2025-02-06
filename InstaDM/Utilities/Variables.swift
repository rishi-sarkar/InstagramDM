import SwiftUI

class UserLogin: ObservableObject {
    @Published var isUserLoggedIn: Bool {
        didSet {
            UserDefaults.standard.set(isUserLoggedIn, forKey: "isUserLoggedIn")
        }
    }
    init() {
        self.isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    }
}

class UpdateMessageView: ObservableObject {

    @Published var updateMessageView = true

    init() {
        self.updateMessageView = false
    }
}

class UpdateRedirectView: ObservableObject {

    @Published var updateRedirectView = true

    init() {
        self.updateRedirectView = false
    }
}

class UpdateProfileView: ObservableObject {

    @Published var updateProfileView = true

    init() {
        self.updateProfileView = false
    }
}
