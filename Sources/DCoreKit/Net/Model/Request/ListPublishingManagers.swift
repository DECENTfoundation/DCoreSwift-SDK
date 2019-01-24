import Foundation

struct ListPublishingManagers: BaseRequestConvertible {
    
    typealias Output = [ChainObject]
    private(set) var base: BaseRequest<[ChainObject]>
    
    init(_ bound: String, limit: Int = 100) {
        self.base = ListPublishingManagers.toBase(
            .database,
            api: "list_publishing_managers",
            returnType: [ChainObject].self,
            params: [bound, limit]
        )
    }
}
