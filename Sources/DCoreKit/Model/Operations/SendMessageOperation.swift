import Foundation

public struct SendMessageOperation: CustomOperation {
    
    public let id: CustomOperationType = .messaging
    public let payer: AccountObjectId
    public let requiredAuths: [AccountObjectId]
    public let data: String
    
    public var fee: AssetAmount = .unset
    
    public init(_ data: String, payer: AccountObjectId) {
        self.data = data.asEncoded().toHex()
        self.payer = payer
        self.requiredAuths = [payer]
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        payer,
        requiredAuths = "required_auths",
        data,
        fee
    }
}
