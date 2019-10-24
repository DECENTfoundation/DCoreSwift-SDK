import Foundation
import BigInt

struct GetNfts: BaseRequestConvertible {
    
    typealias Output = [Nft]
    private(set) var base: BaseRequest<[Nft]>
    
    init(_ ids: [ChainObject]) {
        
        precondition(ids.allSatisfy { $0.objectType == .nftObject }, "Not a valid nft object id")
        self.base = GetNfts.toBase(.database, api: "get_non_fungible_tokens", returnType: [Nft].self, params: [ids])
    }
}
