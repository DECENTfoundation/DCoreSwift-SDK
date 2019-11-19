struct ListNfts: BaseRequestConvertible {
    
    typealias Output = [Nft]
    private(set) var base: BaseRequest<[Nft]>
    
    init(_ bound: String, limit: Int = DCore.Limits.nft) {
        precondition(limit <= DCore.Limits.nft, "Nft limit is out of bound: \(DCore.Limits.nft)")
        self.base = ListNfts.toBase(
            .database, api: "list_non_fungible_tokens", returnType: [Nft].self, params: [bound, limit]
        )
    }
}
