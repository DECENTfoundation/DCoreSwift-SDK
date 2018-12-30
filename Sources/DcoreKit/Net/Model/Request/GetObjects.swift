import Foundation

class GetObjects<T: Codable>: BaseRequest<T> {
    
    init(objects: [ChainObject], returnClass: T.Type) {
        super.init(.database, api: "get_objects", returnClass: returnClass, params: [objects])
    }
}
