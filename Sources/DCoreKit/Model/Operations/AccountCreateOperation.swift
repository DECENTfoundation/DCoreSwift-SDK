import Foundation
import BigInt

public struct AccountCreateOperation: Operation {
    
    public var name: String {
        willSet { precondition(Account.hasValid(name: name), "Not a valid name") }
    }
    
    public let owner: Authority
    public let active: Authority
    public let options: Options
    
    public var registrar: AccountObjectId
    
    public let type: OperationType = .accountCreateOperation
    public var fee: AssetAmount  = .unset
    
    public init(_ account: SubmitAccount, registrar: AccountObjectId, fee: AssetAmount = .unset) {
        self.name = account.name
        self.owner = account.owner
        self.active = account.active
        self.options = account.options
        self.registrar = registrar
        self.fee = fee
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        name,
        owner,
        active,
        options,
        registrar,
        fee
    }
}

extension AccountCreateOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> AccountCreateOperation {
        return self
    }
}

extension AccountCreateOperation {
    public func asData() -> Data {
        
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += registrar.asData()
        data += name.asData()
        data += owner.asData()
        data += active.asData()
        data += options.asData()
        data += Data.ofZero
        
        DCore.Logger.debug(crypto: "AccountCreateOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}

public enum SubmitAccount {
    
    var name: String {
        switch self {
        case .with(let name, _): return name
        case .withKeyPair(let name, _): return name
        }
    }
    
    fileprivate var owner: Authority {
        switch self {
        case .with(_, let address): return Authority(from: address)
        case .withKeyPair(_, let keyPair): return Authority(from: keyPair.address)
        }
    }
    
    fileprivate var active: Authority {
        switch self {
        case .with(_, let address): return Authority(from: address)
        case .withKeyPair(_, let keyPair): return Authority(from: keyPair.address)
        }
    }
    
    fileprivate var options: Options {
        switch self {
        case .with(_, let address): return Options(from: address)
        case .withKeyPair(_, let keyPair): return Options(from: keyPair.address)
        }
    }
    
    case
    with(name: String, address: Address),
    withKeyPair(name: String, keyPair: ECKeyPair)
}
