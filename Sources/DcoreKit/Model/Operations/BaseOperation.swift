import Foundation

public class BaseOperation: Codable {
    
    static let feeUnset = AssetAmount(0)
    
    public var type: OperationType = .unknown
    public var fee: AssetAmount = feeUnset
    
    init(type: OperationType, fee: AssetAmount? = nil) {
        self.type = type
        self.fee = fee.or(BaseOperation.feeUnset)
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        fee
    }
    
    func apply(fee amount: AssetAmount) -> BaseOperation {
        fee = amount
        return self
    }
}

extension BaseOperation: DataEncodable {
    @objc func asData() -> Data {
        let data =  Data.ofZero
        
        Logger.debug(crypto: "BaseOperation binary: %{private}s", args: { "\(data.toHex()) (\(data))"})
        return data
    }
}
