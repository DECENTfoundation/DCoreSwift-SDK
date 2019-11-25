import Foundation

struct GetMessageObjects: BaseRequestConvertible {
    
    typealias Output = [MessageResponse]
    private(set) var base: BaseRequest<[MessageResponse]>
    
    init(_ sender: AccountObjectId?, receiver: AccountObjectId?, limit: Int) {
        precondition(!sender.isNil() || !receiver.isNil(), "At least one of the accounts needs to be specified")
        self.base = GetMessageObjects.toBase(
            .messaging, api: "get_message_objects", returnType: [MessageResponse].self, params: [sender, receiver, limit]
        )
    }
}
