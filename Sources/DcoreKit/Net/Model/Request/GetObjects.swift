import Foundation

class GetObjects<T>: BaseRequest<T> {
    
    init(objects: [ChainObject], returnClass: T.Type) {
        super.init(api: .DATABASE, method: "get_objects", returnClass: returnClass, params: [objects])
    }
}
