import Foundation
import RxSwift

class BaseRequest<T> {
    
    let apiGroup: ApiGroup
    let method: String
    let returnClass: T.Type
    let params: [Any]
    
    var jsonrpc: String = "2.0"
    var id: Int = 1
    
    init(api group: ApiGroup, method: String, returnClass: T.Type, params: [Any] = []) {
        self.apiGroup = group
        self.method = method
        self.returnClass = returnClass
        self.params = params
    }
}

extension BaseRequest {
    func toRequest(core: DCore.Sdk) -> Single<T> {
        return core.make(request: self)
    }
}
