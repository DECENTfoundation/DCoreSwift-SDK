import Foundation

public struct QrTransfer: Equatable {
    public let accountName: String
    public let assetSymbol: String
    public let amount: String
    public let memo: String
    
    public init(
        accountName: String,
        assetSymbol: String = "",
        amount: String = "",
        memo: String = ""
    ) {
        self.accountName = accountName
        self.assetSymbol = assetSymbol
        self.amount = amount
        self.memo = memo
    }
}

public extension QrTransfer {
    func toQrString() -> String? {
        var uri = URLComponents()
        uri.scheme = DCore.Constant.dctQrPrefix
        uri.host = accountName
        uri.queryItems = [
            URLQueryItem(name: "amount", value: amount),
            URLQueryItem(name: "asset", value: assetSymbol),
            URLQueryItem(name: "memo", value: memo)
        ]
        
        return uri.url?.absoluteString.replacingOccurrences(of: "://", with: ":")
    }
}
