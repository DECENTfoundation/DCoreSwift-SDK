import Foundation
import BigInt

public struct BuyContentOperation: Operation {
    
    public var uri: String {
        willSet { precondition(!uri.matches(regex: "^(https?|ipfs|magnet):.*").isEmpty, "Unsupported uri scheme") }
    }
    
    public var consumer: ChainObject {
        willSet { precondition(consumer.objectType == ObjectType.accountObject, "Not an account object id") }
    }
    
    public var price: AssetAmount {
        willSet { precondition(price >= 0, "Price must be >= 0") }
    }
    
    public var publicElGamal: PubKey = PubKey()
    public var regionCode: Int = Regions.NONE.id
    
    public let type: OperationType = .requestToBuyOperation
    public var fee: AssetAmount  = .unset
    
    public init(_ credentials: Credentials, content: Content) {
        
        consumer = credentials.accountId
        uri = content.uri
        price = content.price
        
        if content.uri.asURL()?.type == .ipfs { publicElGamal = PubKey() }
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        uri = "URI",
        consumer,
        price,
        publicElGamal = "pubKey",
        regionCode = "region_code_from"
    }
}

extension BuyContentOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> BuyContentOperation {
        return self
    }
}

extension BuyContentOperation: DataConvertible {
    public func asData() -> Data {
        
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += uri.asData()
        data += consumer.asData()
        data += price.asData()
        data += regionCode.littleEndian
        data += publicElGamal.asData()
        
        DCore.Logger.debug(crypto: "BuyContentOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
