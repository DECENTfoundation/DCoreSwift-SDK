import Foundation
import BigInt

public struct BalanceChange: Codable {
    
    public var history: OperationHistory
    public let balance: Balance
    public let fee: AssetAmount
    
    private enum CodingKeys: String, CodingKey {
        case
        history = "hist_object",
        balance,
        fee
    }
}

extension BalanceChange: Equatable {}

extension BalanceChange: CipherConvertible {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> BalanceChange {
        var change = self
        change.history = try history.decrypt(keyPair, address: address, nonce: nonce)
        
        return change
    }
}

extension BalanceChange: HasOperation {
    public func hasOperation<Output>(type: Output.Type) -> Bool where Output : Operation {
        return history.hasOperation(type: type)
    }
}

public struct Balance: Codable {
    
    public let primaryAsset: AssetAmount
    public let sencodaryAsset: AssetAmount
    
    private enum CodingKeys: String, CodingKey {
        case
        primaryAsset = "asset0",
        sencodaryAsset = "asset1"
    }
}

extension Balance: Equatable {}
