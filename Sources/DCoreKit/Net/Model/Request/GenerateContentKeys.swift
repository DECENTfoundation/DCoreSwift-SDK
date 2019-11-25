import Foundation

struct GenerateContentKeys: BaseRequestConvertible {
    
    typealias Output = ContentKeys
    private(set) var base: BaseRequest<ContentKeys>
    
    init(_ seeders: [AccountObjectId]) {
        self.base = GenerateContentKeys.toBase(
            .database, api: "generate_content_keys", returnType: ContentKeys.self, params: [seeders]
        )
    }
}
