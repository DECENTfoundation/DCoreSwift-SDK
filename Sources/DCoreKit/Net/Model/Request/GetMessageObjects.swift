import Foundation

struct GetMessageObjects: BaseRequestConvertible {
    
    typealias Output = [MessageResponse]
    private(set) var base: BaseRequest<[MessageResponse]>
    
    init(_ sender: ChainObject?, receiver: ChainObject?, limit: Int) {
        self.base = GetMessageObjects.toBase(
            .messaging, api: "get_message_objects", returnType: [MessageResponse].self, params: [sender, receiver, limit]
        )
    }
}
