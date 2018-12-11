import Foundation

class RequestApiAccess: BaseRequest<Int> {
 
    required init(api group: ApiGroup) {
        super.init(api: .LOGIN, method: group.rawValue, returnClass: Int.self, params: [])
    }
}
