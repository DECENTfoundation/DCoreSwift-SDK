import Foundation

public struct BuyContentOperation: Operation {
    
    public var uri: String {
        willSet { precondition(!uri.matches(regex: "^(https?|ipfs|magnet):.*").isEmpty, "Unsupported uri scheme") }
    }
    
    public var consumer: ChainObject {
        willSet { precondition(consumer.objectType == ObjectType.accountObject, "Not an account object id") }
    }
    
    public var price: AssetAmount {
        willSet { precondition(price >= 0, "Price must be >= 0") }
    }
    
    public var publicElGamal: PubKey = PubKey()
    public var regionCode: Int = Regions.NONE.id
    
    public let type: OperationType = .requestToBuyOperation
    public var fee: AssetAmount  = .unset
    
    public init(_ credentials: Credentials, content: Content) {
        
        consumer = credentials.accountId
        uri = content.uri
        price = content.price
        
        if content.uri.asURL()?.type == .ipfs { publicElGamal = PubKey() }
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        uri = "URI",
        consumer,
        price,
        publicElGamal = "pubKey",
        regionCode = "region_code_from"
    }
}

extension BuyContentOperation: DataEncodable {
    
    func asData() -> Data {
        
        var data = Data()
        data += type
        data += fee
        data += VarInt(uri.asData().count)
        data += uri
        data += consumer
        data += price
        data += regionCode
        data += publicElGamal
        
        Logger.debug(crypto: "BuyContentOperation binary: %{private}s", args: { "\(data.toHex()) (\(data))"})
        return data
    }
}
