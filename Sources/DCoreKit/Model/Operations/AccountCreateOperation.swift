import Foundation

public struct AccountCreateOperation: Operation {
    
    public var name: String {
        willSet { precondition(Account.hasValid(name: name), "Not a valid name") }
    }
    
    public var owner: Authority
    public var active: Authority
    public var options: Options
    
    public var registrar: ChainObject {
        willSet { precondition(registrar.objectType == ObjectType.accountObject, "Not an account object id") }
    }
    
    public let type: OperationType = .accountCreateOperation
    public var fee: AssetAmount  = .unset
    
    public init(_ registrar: ChainObject, name: String, address: Address, fee: AssetAmount = .unset) {
        self.registrar = registrar
        self.name = name
        self.owner = Authority(from: address)
        self.active = Authority(from: address)
        self.options = Options(from: address)
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
