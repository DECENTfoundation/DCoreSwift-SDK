import Foundation

class Login : BaseRequest<Bool> {
 
    required init() {
        super.init(api: .LOGIN, method: "login", returnClass: Bool.self, params: ["", ""])
    }
}
