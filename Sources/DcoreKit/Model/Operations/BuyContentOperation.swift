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
        
        self.consumer = credentials.accountId
        self.uri = content.uri
        self.price = content.price
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
        
        Logger.debug(crypto: "BuyContentOperation binary: %{private}s", args: { "\(data.toHex()) (\(data))"})
        return data
    }
}
/*
public struct BuyContentOperation: Operation {
    
    public let uri: String
    public let consumer: ChainObject
    public let price: AssetAmount
    public let publicElGamal: PubKey
    public let regionCode: Int
    
    public let type: OperationType = .requestToBuyOperation
    public var fee: AssetAmount  = .unset
    
    public init(_ uri: String,
                consumer: ChainObject,
                price: AssetAmount,
                publicElGamal: PubKey,
                regionCode: Int = Regions.NONE.id,
                fee: AssetAmount = .unset) {
        
        precondition(consumer.objectType == ObjectType.accountObject, "Not an account object id")
        precondition(price >= 0, "Price must be >= 0")
        precondition(!uri.matches(regex: "^(https?|ipfs|magnet):.*").isEmpty, "Unsupported uri scheme")
    
        self.uri = uri
        self.consumer = consumer
        self.price = price
        self.publicElGamal = publicElGamal
        self.regionCode = regionCode
    }
    
    public init(credentials: Credentials, content: Content) {
        self.init(content.uri, consumer: credentials.accountId, price: content.price, publicElGamal: PubKey())
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        uri = "URI",
        consumer,
        price,
        publicElGamal = "pubKey",
        regionCode = "region_code_from"
    }
    
    func asData() -> Data {
        var data = Data()
        data += type
        data += fee
        data += VarInt(uri.data(using: .ascii)!.count)
        data += uri
        data += consumer
        data += price
        data += regionCode
        data += publicElGamal
        
        Logger.debug(crypto: "BuyContentOperation binary: %{private}s", args: { "\(data.toHex()) (\(data))"})
        return data
    }
}
*/
