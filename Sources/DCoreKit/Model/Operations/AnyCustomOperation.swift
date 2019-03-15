import Foundation

public struct AnyCustomOperation: CustomOperation {
    
    public let id: CustomOperationType
    public let payee: ChainObject
    public let requiredAuths: [ChainObject]
    public let data: String
    
    public var fee: AssetAmount = .unset
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        payee = "payer",
        requiredAuths = "required_auths",
        data,
        fee
    }
}
