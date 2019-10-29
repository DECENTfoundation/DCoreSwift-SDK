struct ListNftData: BaseRequestConvertible {
    
    typealias Output = [NftData<RawNft>]
    private(set) var base: BaseRequest<[NftData<RawNft>]>
    
    init(_ nftId: ChainObject) {
        
        precondition(nftId.objectType == .nftObject, "Not a valid nft object id")
        self.base = ListNftData.toBase(
            .database, api: "list_non_fungible_token_data", returnType: [NftData<RawNft>].self, params: [nftId]
        )
    }
}
