import Foundation

struct GetSeeder: BaseRequestConvertible {
    
    typealias Output = Seeder
    private(set) var base: BaseRequest<Seeder>
    
    init(_ accountId: AccountObjectId) {
        self.base = GetSeeder.toBase(.database, api: "get_seeder", returnType: Seeder.self, params: [accountId])
    }
}
