import Foundation

struct GetMessageObjects: BaseRequestConvertible {
    
    typealias Output = [MessageResponse]
    private(set) var base: BaseRequest<[MessageResponse]>
    
    init(_ sender: ChainObject?, receiver: ChainObject?, limit: Int) {
        
        precondition(sender.isNil() || sender?.objectType == .accountObject, "Not a valid account object id")
        precondition(receiver.isNil() || receiver?.objectType == .accountObject, "Not a valid account object id")
        precondition(!sender.isNil() || !receiver.isNil(), "At least one of the accounts needs to be specified")
        self.base = GetMessageObjects.toBase(
            .messaging, api: "get_message_objects", returnType: [MessageResponse].self, params: [sender, receiver, limit]
        )
    }
}
