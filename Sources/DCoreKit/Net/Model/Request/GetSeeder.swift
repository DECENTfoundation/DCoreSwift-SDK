import Foundation

struct GetSeeder: BaseRequestConvertible {
    
    typealias Output = Seeder
    private(set) var base: BaseRequest<Seeder>
    
    init(_ accountId: ChainObject) {
        
        precondition(accountId.objectType == .accountObject, "Not a valid account object id")
        self.base = GetSeeder.toBase(.database, api: "get_seeder", returnType: Seeder.self, params: [accountId])
    }
}
