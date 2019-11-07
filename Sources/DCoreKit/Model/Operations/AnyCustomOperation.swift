import Foundation

public struct AnyCustomOperation: CustomOperation {
    
    public let id: CustomOperationType
    public let payer: AccountObjectId
    public let requiredAuths: [AccountObjectId]
    public let data: String
    
    public var fee: AssetAmount = .unset
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        payer,
        requiredAuths = "required_auths",
        data,
        fee
    }
}
