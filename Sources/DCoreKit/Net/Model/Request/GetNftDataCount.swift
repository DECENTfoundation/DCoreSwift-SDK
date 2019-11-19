struct GetNftDataCount: BaseRequestConvertible {
    
    typealias Output = UInt64
    private(set) var base: BaseRequest<UInt64>
    
    init() {
        self.base = GetNftDataCount.toBase(.database, api: "get_non_fungible_token_data_count", returnType: UInt64.self)
    }
}
