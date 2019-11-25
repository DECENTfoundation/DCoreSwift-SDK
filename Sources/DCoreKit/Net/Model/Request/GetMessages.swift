import Foundation

struct GetMessages: BaseRequestConvertible {
    
    typealias Output = [MessageResponse]
    private(set) var base: BaseRequest<[MessageResponse]>
    
    init(_ messages: [MessagingObjectId]) {
        self.base = GetMessages.toBase(
            .messaging, api: "get_messages", returnType: [MessageResponse].self, params: [messages]
        )
    }
}
