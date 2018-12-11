import Foundation

class Info: BaseRequest<String> {
 
    required init() {
        super.init(api: .DATABASE, method: "info", returnClass: String.self)
    }
}
