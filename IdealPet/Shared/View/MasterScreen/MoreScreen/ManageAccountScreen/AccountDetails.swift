import Foundation

struct AccountDetails {
    var name: String
    var phoneNum: String
    var email: String
    var password: String
}

extension AccountDetails {
    static var new: AccountDetails{
        AccountDetails(name: "", phoneNum: "", email: "", password: "")
    }
}
