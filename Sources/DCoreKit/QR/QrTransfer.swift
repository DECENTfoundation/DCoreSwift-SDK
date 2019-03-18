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

private let amountKey = "amount"
private let assetKey = "asset"
private let memoKey = "memo"

public extension QrTransfer {
    func toQrString() -> String? {
        var uri = URLComponents()
        uri.scheme = DCore.Constant.dctQrPrefix
        uri.host = accountName
        uri.queryItems = [
            URLQueryItem(name: amountKey, value: amount),
            URLQueryItem(name: assetKey, value: assetSymbol),
            URLQueryItem(name: memoKey, value: memo)
        ]
        
        return uri.url?.absoluteString.replacingOccurrences(of: "://", with: ":")
    }
}

public protocol QrTransferConvertible {
    func asQrTransfer() -> QrTransfer?
}

extension String: QrTransferConvertible {
    public func asQrTransfer() -> QrTransfer? {
        guard let uri = URLComponents(string:
            replacingOccurrences(of: "\(DCore.Constant.dctQrPrefix):", with: "\(DCore.Constant.dctQrPrefix)://")
        ) else { return nil }

        return QrTransfer(
            accountName: uri.host ?? "",
            assetSymbol: uri.value(for: assetKey) ?? "",
            amount: uri.value(for: amountKey) ?? "",
            memo: uri.value(for: memoKey) ?? ""
        )
    }
}

private extension URLComponents {
    func value(for queryName: String) -> String? {
        return queryItems?.first { $0.name == queryName }?.value
    }
}
