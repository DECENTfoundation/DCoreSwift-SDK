import Foundation

public final class TransferOperation: BaseOperation {
    
    public let from: ChainObject
    public let to: ChainObject
    public let amount: AssetAmount
    public var memo: Memo?
    
    public init(from: ChainObject, to: ChainObject, amount: AssetAmount, memo: Memo? = nil, fee: AssetAmount? = nil) {
        self.from = from
        self.to = to
        self.amount = amount
        self.memo = memo
        
        super.init(type: .transferTwoOperation, fee: fee)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        from =     try container.decode(ChainObject.self, forKey: .from)
        to =       try container.decode(ChainObject.self, forKey: .to)
        amount =   try container.decode(AssetAmount.self, forKey: .amount)
        memo =     try? container.decode(Memo.self, forKey: .memo)
        
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(from, forKey: .from)
        try container.encode(to, forKey: .to)
        try container.encode(amount, forKey: .amount)
        
        if let memo = memo { try container.encode(memo, forKey: .memo) }
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
