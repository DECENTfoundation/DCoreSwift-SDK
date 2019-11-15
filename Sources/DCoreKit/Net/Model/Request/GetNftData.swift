struct GetNftData: BaseRequestConvertible {
    
    typealias Output = [NftData<RawNft>]
    private(set) var base: BaseRequest<[NftData<RawNft>]>
    
    init(_ ids: [ChainObject]) {
        
        precondition(ids.allSatisfy { $0.objectType == .nftDataObject }, "Not a valid nft data object id")
        self.base = GetNftData.toBase(
            .database, api: "get_non_fungible_token_data", returnType: [NftData<RawNft>].self, params: [ids]
        )
    }
}
