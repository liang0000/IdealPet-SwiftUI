import Foundation

struct SignInCredentials{
    var email: String
    var password: String
}

extension SignInCredentials {
    static var new: SignInCredentials{
        SignInCredentials(email: "", password: "")
    }
}
