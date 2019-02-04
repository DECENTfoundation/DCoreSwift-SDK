import Foundation

struct FeeOperation: Operation {
    
    var fee: AssetAmount = .unset
    var type: OperationType = .unknown
 
    init(_ type: OperationType) {
        self.type = type
    }

    private enum CodingKeys: String, CodingKey {
        case
        fee
    }
}
