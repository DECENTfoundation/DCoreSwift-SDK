import Foundation

public struct AccountUpdateOperation: Operation {
    
    public let accountId: ChainObject
    public var owner: Authority?
    public var active: Authority?
    public var options: Options?
    
    public let type: OperationType = .accountUpdateOperation
    public var fee: AssetAmount  = .unset
    
    private enum CodingKeys: String, CodingKey {
        case
        accountId = "account",
        owner,
        active,
        options = "new_options",
        fee
    }
}

extension AccountUpdateOperation {
    public func asData() -> Data {
        
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += accountId.asData()
        data += owner.asData()
        data += active.asData()
        data += options.asData()
        data += Data.ofZero
        
        Logger.debug(crypto: "AccountUpdateOperation binary: %{private}s", args: { "\(data.toHex()) (\(data)) \(data.bytes)"})
        return data
    }
}
