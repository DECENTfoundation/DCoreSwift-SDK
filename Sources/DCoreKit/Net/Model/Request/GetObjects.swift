import Foundation

struct GetObjects<Object>: BaseRequestConvertible where Object: Codable {
    
    typealias Output = Object
    private(set) var base: BaseRequest<Object>
    
    init(_ ids: [ObjectId], returnType: Object.Type) {
        self.base = GetObjects.toBase(.database, api: "get_objects", returnType: returnType, params: [ids])
    }
}
