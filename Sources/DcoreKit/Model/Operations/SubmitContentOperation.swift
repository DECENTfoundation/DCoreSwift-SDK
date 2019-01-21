import Foundation

public struct SubmitContentOperation: Operation {
    
    public let type: OperationType = .contentSubmitOperation
    public var fee: AssetAmount  = .unset
}

extension SubmitContentOperation {
    public func asData() -> Data {
        
        let data = Data.ofZero
        Logger.debug(crypto: "SubmitContentOperation binary: %{private}s", args: { "\(data.toHex()) (\(data)) [\(data.bytes)]"})
        return data
    }
}
