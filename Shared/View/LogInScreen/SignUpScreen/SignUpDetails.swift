import Foundation

struct SignUpDetails {
    var name: String
    var email: String
    var phoneNum: String
    var password: String
}

extension SignUpDetails {
    static var new: SignUpDetails{
        SignUpDetails(name: "", email: "", phoneNum: "", password: "")
    }
}
