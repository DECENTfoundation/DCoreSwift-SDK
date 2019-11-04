struct GetNftsBalances: BaseRequestConvertible {
    
    typealias Output = [NftData<RawNft>]
    private(set) var base: BaseRequest<[NftData<RawNft>]>
    
    init(_ accountId: ChainObject, _ nftIds: [ChainObject]) {
        precondition(accountId.objectType == .accountObject, "Not a valid account object id")
        precondition(nftIds.allSatisfy { $0.objectType == .nftObject }, "Not a valid nft object id")
        self.base = ListNftData.toBase(
            .database,
            api: "get_non_fungible_token_balances",
            returnType: [NftData<RawNft>].self,
            params: [accountId, nftIds]
        )
    }
}
