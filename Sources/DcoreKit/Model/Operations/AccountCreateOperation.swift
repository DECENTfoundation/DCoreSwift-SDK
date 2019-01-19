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
    func asData() -> Data {
        
        var data = Data()
        
        Logger.debug(crypto: "AccountCreateOperation binary: %{private}s", args: { "\(data.toHex()) (\(data))"})
        return data
    }
}
