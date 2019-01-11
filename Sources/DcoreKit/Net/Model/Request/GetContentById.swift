import Foundation

struct GetContentById: BaseRequestConvertible {
    
    typealias Output = [Content]
    private(set) var base: BaseRequest<[Content]>
    
    init(_ contentId: ChainObject) {
        
        precondition(contentId.objectType == .contentObject, "Not a valid content object id")
        self.base = GetObjects([contentId], returnClass: [Content].self).base
    }
}
