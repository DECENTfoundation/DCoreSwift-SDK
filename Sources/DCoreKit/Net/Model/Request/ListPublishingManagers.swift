import Foundation

struct ListPublishingManagers: BaseRequestConvertible {
    
    typealias Output = [AccountObjectId]
    private(set) var base: BaseRequest<[AccountObjectId]>
    
    init(_ bound: String, limit: Int = 100) {
        self.base = ListPublishingManagers.toBase(
            .database,
            api: "list_publishing_managers",
            returnType: [AccountObjectId].self,
            params: [bound, limit]
        )
    }
}
