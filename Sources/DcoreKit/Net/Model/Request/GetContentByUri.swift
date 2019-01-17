import Foundation

struct GetContentByUri: BaseRequestConvertible {
    
    typealias Output = Content
    private(set) var base: BaseRequest<Content>
    
    init(_ uri: String) {
        self.base = GetContentByUri.toBase(.database, api: "get_content", returnType: Content.self, params: [uri])
    }
}
