import Foundation

struct GetMessages: BaseRequestConvertible {
    
    typealias Output = [MessageResponse]
    private(set) var base: BaseRequest<[MessageResponse]>
    
    init(_ messages: [ChainObject]) {
        
        precondition(messages.allSatisfy { $0.objectType == .messagingObject }, "Not a valid message object id")
        self.base = GetMessages.toBase(
            .messaging, api: "get_messages", returnType: [MessageResponse].self, params: [messages]
        )
    }
}
