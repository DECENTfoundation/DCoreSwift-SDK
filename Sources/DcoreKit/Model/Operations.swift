import Foundation

public class BaseOperation: Codable {
    
    static let FEE_UNSET = AssetAmount(0)
    
    public let type: OperationType
    public var fee: AssetAmount = FEE_UNSET

    init(type: OperationType, fee: AssetAmount? = nil) {
        self.type = type
        self.fee = fee ?? BaseOperation.FEE_UNSET
    }

    private enum CodingKeys: String, CodingKey {
        case
        type,
        fee
    }
}

extension BaseOperation: DataSerializable {}
extension BaseOperation: Equatable {
    public static func == (lhs: BaseOperation, rhs: BaseOperation) -> Bool {
        return lhs.serialized == rhs.serialized
    }
}

public final class EmptyOperation: BaseOperation {
    public var serialized: Data {
        return Data(count: 1)
    }
}

public final class TransferOperation: BaseOperation {
    public let from: ChainObject
    public let to: ChainObject
    public let amount: AssetAmount
    public let memo: Memo?
    
    public init(from: ChainObject, to: ChainObject, amount: AssetAmount, memo: Memo? = nil, fee: AssetAmount? = nil) {
        self.from = from
        self.to = to
        self.amount = amount
        self.memo = memo
        
        super.init(type: .TRANSFER2_OPERATION, fee: fee)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.from =     try container.decode(ChainObject.self, forKey: .from)
        self.to =       try container.decode(ChainObject.self, forKey: .to)
        self.amount =   try container.decode(AssetAmount.self, forKey: .amount)
        self.memo =     try? container.decode(Memo.self, forKey: .memo)
        
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.from, forKey: .from)
        try container.encode(self.to, forKey: .to)
        try container.encode(self.amount, forKey: .amount)
        
        if let memo = self.memo { try container.encode(memo, forKey: .memo) }
        else { try container.encodeNil(forKey: .memo) }
  
        try super.encode(to: encoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        from,
        to,
        amount,
        memo
    }

    public var serialized: Data {
        var data = Data()
        data += Data(count: type.rawValue)
        data += fee
        data += from
        data += to.objectTypeId
        data += amount
        data += (memo?.serialized ?? Data(count: 0))
        data += Data(count: 1)
        return data
    }
}

/*

public final class BuyContentOperation: BaseOperation {
    public let uri: String
    public let consumer: ChainObject
    public let price: AssetAmount
    public let publicElGamal: PubKey
    public let regionCode: Int
    
    public init(uri: String, consumer: ChainObject, price: AssetAmount, publicElGamal: PubKey, regionCode: Int = Regions.NONE.id, fee: AssetAmount? = nil) {
        guard consumer.objectType == ObjectType.ACCOUNT_OBJECT else { preconditionFailure("not an account object id") }
        guard price >= 0 else { preconditionFailure("price must be >= 0") }
        // require(Pattern.compile("^(https?|ipfs|magnet):.*").matcher(uri).matches()) { "unsupported uri scheme" }
        self.uri = uri
        self.consumer = consumer
        self.price = price
        self.publicElGamal = publicElGamal
        self.regionCode = regionCode
        
        super.init(type: .REQUEST_TO_BUY_OPERATION, fee: fee)
    }
    
    public convenience init(credentials: Credentials, content: Content) {
        self.init(uri: content.uri, consumer: credentials.accountId, price: content.price, publicElGamal: PubKey())
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        uri = "URI",
        consumer,
        price,
        publicElGamal = "pubKey",
        regionCode = "region_code_from"
    }
    
    public var serialized: Data {
        var data = Data()
        data += Data(count: type.rawValue)
        data += fee
        data += VarInt(uri.data(using: .ascii)!.count)
        data += uri
        data += consumer
        data += price
        data += regionCode
        data += publicElGamal
        return data
    }
}
*/
