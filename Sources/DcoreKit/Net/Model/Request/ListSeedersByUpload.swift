import Foundation

struct ListSeedersByUpload: BaseRequestConvertible {
    
    typealias Output = [Seeder]
    private(set) var base: BaseRequest<[Seeder]>
    
    init(_ count: Int = 100) {
        self.base = ListSeedersByUpload.toBase(.database, api: "list_seeders_by_upload", returnClass: [Seeder].self, params: [count])
    }
}
