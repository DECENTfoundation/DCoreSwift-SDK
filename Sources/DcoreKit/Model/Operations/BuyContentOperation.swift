import Foundation

public final class BuyContentOperation: BaseOperation {
    public let uri: String
    public let consumer: ChainObject
    public let price: AssetAmount
    public let publicElGamal: PubKey
    public let regionCode: Int
    
    public init(uri: String,
                consumer: ChainObject,
                price: AssetAmount,
                publicElGamal: PubKey,
                regionCode: Int = Regions.NONE.id,
                fee: AssetAmount? = nil) {
        
        precondition(consumer.objectType == ObjectType.accountObject, "Not an account object id")
        precondition(price >= 0, "Price must be >= 0")
        precondition(!uri.matches(regex: "^(https?|ipfs|magnet):.*").isEmpty, "Unsupported uri scheme")
    
        self.uri = uri
        self.consumer = consumer
        self.price = price
        self.publicElGamal = publicElGamal
        self.regionCode = regionCode
        
        super.init(type: .requestToBuyOperation, fee: fee)
    }
    
    public convenience init(credentials: Credentials, content: Content) {
        self.init(uri: content.uri, consumer: credentials.accountId, price: content.price, publicElGamal: PubKey())
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        uri =           try container.decode(String.self, forKey: .uri)
        consumer =      try container.decode(ChainObject.self, forKey: .consumer)
        price =         try container.decode(AssetAmount.self, forKey: .price)
        publicElGamal = try container.decode(PubKey.self, forKey: .publicElGamal)
        regionCode =    try container.decode(Int.self, forKey: .regionCode)
        
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uri, forKey: .uri)
        try container.encode(consumer, forKey: .consumer)
        try container.encode(price, forKey: .price)
        try container.encode(publicElGamal, forKey: .publicElGamal)
        try container.encode(regionCode, forKey: .regionCode)
        
        try super.encode(to: encoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        uri = "URI",
        consumer,
        price,
        publicElGamal = "pubKey",
        regionCode = "region_code_from"
    }
    
    override func asData() -> Data {
        var data = Data()
        data += Data(count: type.rawValue)
        data += fee
        data += VarInt(uri.data(using: .ascii)!.count)
        data += uri
        data += consumer
        data += price
        data += regionCode
        data += publicElGamal
        
        Logger.debug(crypto: "BuyContentOperation binary: %{private}s", args: { "\(data.toHex())(\(data))"})
        return data
    }
}
