import Foundation

public struct OperationHistory {
    
    public let id: ChainObject
    public let operation: Operation
    public let result: AnyValue?
    public let blockNum: UInt64
    public let trxInBlock: UInt64
    public let operationNumInTrx: UInt64
    public let virtualOperation: UInt64
}

extension OperationHistory: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        operation = "op",
        result,
        blockNum = "block_num",
        trxInBlock = "trx_in_block",
        operationNumInTrx = "op_in_trx",
        virtualOperation = "virtual_op"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id =                try container.decode(ChainObject.self, forKey: .id)
        result =            try container.decodeIfPresent(AnyValue.self, forKey: .result)
        blockNum =          try container.decode(UInt64.self, forKey: .blockNum)
        trxInBlock =        try container.decode(UInt64.self, forKey: .trxInBlock)
        operationNumInTrx = try container.decode(UInt64.self, forKey: .operationNumInTrx)
        virtualOperation =  try container.decode(UInt64.self, forKey: .virtualOperation)
        
        operation = try container.decode(AnyOperation.self, forKey: .operation).operation
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(result, forKey: .result)
        try container.encode(blockNum, forKey: .blockNum)
        try container.encode(trxInBlock, forKey: .trxInBlock)
        try container.encode(operationNumInTrx, forKey: .operationNumInTrx)
        try container.encode(virtualOperation, forKey: .virtualOperation)
        
        try container.encode(operation.asAnyOperation(), forKey: .operation)
    }
}

extension OperationHistory: Equatable {
    public static func == (lhs: OperationHistory, rhs: OperationHistory) -> Bool {
        return lhs.id == rhs.id
    }
}
