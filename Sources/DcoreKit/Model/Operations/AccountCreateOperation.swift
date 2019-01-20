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
    
    public init(_ registrar: ChainObject, name: String, address: Address) {
        self.registrar = registrar
        self.name = name
        self.owner = Authority(from: address)
        self.active = Authority(from: address)
        self.options = Options(from: address)
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

extension AccountCreateOperation: DataEncodable {
    
    public func asData() -> Data {
        
        var data = Data()
        data += type
        data += fee
        data += registrar
        data += name
        data += owner
        data += active
        data += options
        data += Data.ofZero
        
        Logger.debug(crypto: "AccountCreateOperation binary: %{private}s", args: { "\(data.toHex()) (\(data))"})
        return data
    }
}
