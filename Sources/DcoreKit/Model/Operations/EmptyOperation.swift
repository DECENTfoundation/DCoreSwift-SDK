import Foundation

public final class EmptyOperation: BaseOperation {
    override func asData() -> Data {
        let data =  Data.ofZero
        
        Logger.debug(crypto: "EmptyOperation binary: %{private}s", args: { "\(data.toHex())(\(data))"})
        return data
    }
}
