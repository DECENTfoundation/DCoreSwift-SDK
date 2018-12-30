import Foundation

class Login : BaseRequest<Bool> {
 
    required init() {
        super.init(.login, api: "login", returnClass: Bool.self, params: ["", ""])
    }
}
