struct ListNftData: BaseRequestConvertible {
    
    typealias Output = [NftData<RawNft>]
    private(set) var base: BaseRequest<[NftData<RawNft>]>
    
    init(_ nftId: NftObjectId) {
        self.base = ListNftData.toBase(
            .database, api: "list_non_fungible_token_data", returnType: [NftData<RawNft>].self, params: [nftId]
        )
    }
}
