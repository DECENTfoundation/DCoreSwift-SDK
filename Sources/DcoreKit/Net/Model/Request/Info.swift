import Foundation

class Info: BaseRequest<String> {
 
    required init() {
        super.init(.database, api: "info", returnClass: String.self)
    }
}
