import Foundation

public struct AnyCustomOperation: CustomOperation {
    
    public let id: CustomOperationType
    public let payer: AccountObjectId
    public let requiredAuths: [AccountObjectId]
    public let data: String
    
    public var fee: AssetAmount = .unset

    /**
     Creates AnyCustomOperation
     - Parameter id: type of Custom Operation
     - Parameter payer: account id of payer
     - Parameter requiredAuths: Accounts required to authorize this operation with signature. If not supplied, payer account will be used
     - Parameter data: String data payload, i.e. JSON, XML etc.
     */
    public init(
        id: CustomOperationType,
        payer: AccountObjectId,
        requiredAuths: [AccountObjectId]? = nil,
        data: String
    ) {
        self.init(id: id, payer: payer, requiredAuths: requiredAuths, data: data.asEncoded())
    }

    /**
     Creates AnyCustomOperation
     - Parameter id: type of Custom Operation
     - Parameter payer: account id of payer
     - Parameter requiredAuths: Accounts required to authorize this operation with signature. If not supplied, payer account will be used
     - Parameter data: Data payload
     */
    public init(
        id: CustomOperationType,
        payer: AccountObjectId,
        requiredAuths: [AccountObjectId]? = nil,
        data: Data
    ) {
        self.id = id
        self.payer = payer
        self.requiredAuths = requiredAuths ?? [payer]
        self.data = data.toHex()
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
