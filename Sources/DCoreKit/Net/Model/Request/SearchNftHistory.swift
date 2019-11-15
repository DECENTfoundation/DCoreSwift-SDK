struct SearchNftHistory: BaseRequestConvertible {
    
    typealias Output = [TransactionDetail]
    private(set) var base: BaseRequest<[TransactionDetail]>
    
    init(_ nftDataId: ChainObject) {
        precondition(nftDataId.objectType == .nftDataObject, "Not a valid nft data object id")
        self.base = SearchNftHistory.toBase(
            .database,
            api: "search_non_fungible_token_history",
            returnType: [TransactionDetail].self,
            params: [nftDataId]
        )
    }
}
