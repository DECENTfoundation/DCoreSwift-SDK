import Foundation

public struct OperationHistory: Codable {
    public let id: ChainObject
    public let operation: BaseOperation
    public let result: AnyValue?
    public let blockNum: UInt64
    public let trxInBlock: UInt64
    public let operationNumInTrx: UInt64
    public let virtualOperation: UInt64
    
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
}
