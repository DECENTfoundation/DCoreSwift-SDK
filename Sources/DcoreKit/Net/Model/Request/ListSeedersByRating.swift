import Foundation

struct ListSeedersByRating: BaseRequestConvertible {
    
    typealias Output = [Seeder]
    private(set) var base: BaseRequest<[Seeder]>
    
    init(_ count: Int = 100) {
        self.base = ListSeedersByRating.toBase(
            .database,
            api: "list_seeders_by_rating",
            returnType: [Seeder].self,
            params: [count]
        )
    }
}
