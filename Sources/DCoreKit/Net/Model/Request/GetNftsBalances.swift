struct GetNftsBalances: BaseRequestConvertible {
    
    typealias Output = [NftData<RawNft>]
    private(set) var base: BaseRequest<[NftData<RawNft>]>
    
    init(_ accountId: AccountObjectId, _ nftIds: [NftObjectId]) {
        self.base = ListNftData.toBase(
            .database,
            api: "get_non_fungible_token_balances",
            returnType: [NftData<RawNft>].self,
            params: [accountId, nftIds]
        )
    }
}
