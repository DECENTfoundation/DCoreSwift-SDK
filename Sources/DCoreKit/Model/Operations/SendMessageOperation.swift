import Foundation

public struct SendMessageOperation: CustomOperation {
    
    public let id: CustomOperationType = .messaging
    public let payee: ChainObject
    public let requiredAuths: [ChainObject]
    public let data: String
    
    public var fee: AssetAmount = .unset
    
    public init(_ data: String, payee: ChainObject) {
        self.data = data.asEncoded().toHex()
        self.payee = payee
        self.requiredAuths = [payee]
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        payee = "payer",
        requiredAuths = "required_auths",
        data,
        fee
    }
}
