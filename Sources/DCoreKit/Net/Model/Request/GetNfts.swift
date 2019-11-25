struct GetNfts: BaseRequestConvertible {
    
    typealias Output = [Nft]
    private(set) var base: BaseRequest<[Nft]>
    
    init(_ ids: [NftObjectId]) {
        self.base = GetNfts.toBase(.database, api: "get_non_fungible_tokens", returnType: [Nft].self, params: [ids])
    }
}
