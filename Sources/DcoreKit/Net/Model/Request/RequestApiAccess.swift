import Foundation

class RequestApiAccess: BaseRequest<Int> {
 
    required init(api group: ApiGroup) {
        super.init(.login, api: group.name, returnClass: Int.self, params: [])
    }
}
