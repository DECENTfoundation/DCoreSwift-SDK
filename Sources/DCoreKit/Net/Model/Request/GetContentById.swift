import Foundation

struct GetContentById: BaseRequestConvertible {
    
    typealias Output = [Content]
    private(set) var base: BaseRequest<[Content]>
    
    init(_ contentId: ContentObjectId) {
        self.base = GetObjects([contentId], returnType: [Content].self).base
    }
}
