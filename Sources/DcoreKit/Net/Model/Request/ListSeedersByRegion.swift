import Foundation

struct ListSeedersByRegion: BaseRequestConvertible {
    
    typealias Output = [Seeder]
    private(set) var base: BaseRequest<[Seeder]>
    
    init(_ region: String) {
        self.base = ListSeedersByRegion.toBase(.database, api: "list_seeders_by_region", returnClass: [Seeder].self, params: [region])
    }
}
