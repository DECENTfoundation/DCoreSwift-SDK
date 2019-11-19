struct GetNftCount: BaseRequestConvertible {
    
    typealias Output = UInt64
    private(set) var base: BaseRequest<UInt64>
    
    init() {
        self.base = GetNftCount.toBase(.database, api: "get_non_fungible_token_count", returnType: UInt64.self)
    }
}
