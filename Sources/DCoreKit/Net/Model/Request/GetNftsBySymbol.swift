struct GetNftsBySymbol: BaseRequestConvertible {
    
    typealias Output = [Nft]
    private(set) var base: BaseRequest<[Nft]>
    
    init(_ symbols: [String]) {
        self.base = GetNftsBySymbol.toBase(
            .database, api: "get_non_fungible_tokens_by_symbols", returnType: [Nft].self, params: [symbols])
    }
}
