import Foundation

struct ListSeedersByPrice: BaseRequestConvertible {
    
    typealias Output = [Seeder]
    private(set) var base: BaseRequest<[Seeder]>
    
    init(_ count: Int = 100) {
        self.base = ListSeedersByPrice.toBase(.database, api: "list_seeders_by_price", returnClass: [Seeder].self, params: [count])
    }
}
