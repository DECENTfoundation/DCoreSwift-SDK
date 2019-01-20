import Foundation

public struct CancelContentOperation: Operation {
    
    public let type: OperationType = .contentCancellationOperation
    public var fee: AssetAmount  = .unset
}

extension CancelContentOperation: DataEncodable {
    public func asData() -> Data {
        
        let data = Data.ofZero
        Logger.debug(crypto: "CancelContentOperation binary: %{private}s", args: { "\(data.toHex()) (\(data))"})
        return data
    }
}
