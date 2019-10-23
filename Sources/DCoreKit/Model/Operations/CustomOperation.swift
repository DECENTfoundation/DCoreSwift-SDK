import Foundation

public protocol CustomOperation: Operation {
    var id: CustomOperationType { get }
    var payee: ChainObject { get }
    var requiredAuths: [ChainObject] { get }
    var data: String { get }
}

extension CustomOperation {
    public var type: OperationType { return .customOperation }
}

extension CustomOperation {
    public func asData() -> Data {
        let dataBytes = data.unhex().or(Data.empty)

        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += payee.asData()
        data += requiredAuths.asData()
        data += id.asData()
        data += UInt64(dataBytes.count).asUnsignedVarIntData()
        data += dataBytes
        
        DCore.Logger.debug(crypto: "CustomOperationOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
