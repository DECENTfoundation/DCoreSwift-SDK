import Foundation
import BigInt

public struct PurchaseContentOperation: Operation {
    
    public var uri: String {
        willSet { precondition(Content.hasValid(uri: uri), "Unsupported uri scheme") }
    }
    
    public var consumer: ChainObject {
        willSet { precondition(consumer.objectType == ObjectType.accountObject, "Not an account object id") }
    }
    
    public var price: AssetAmount {
        willSet { precondition(price >= 0, "Price must be >= 0") }
    }
    
    public var publicElGamal: PubKey = PubKey()
    public var regionCode: Int = Regions.none.id
    
    public let type: OperationType = .requestToBuyOperation
    public var fee: AssetAmount  = .unset
    
    public init(_ credentials: Credentials, content: Content) {
        
        consumer = credentials.accountId
        uri = content.uri
        price = content.price
        
        if content.uri.asURL()?.type == .ipfs { publicElGamal = credentials.keyPair.elGamalKeyPair.publicKey }
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        uri = "URI",
        consumer,
        price,
        publicElGamal = "pubKey",
        regionCode = "region_code_from",
        fee
    }
}

extension PurchaseContentOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> PurchaseContentOperation {
        return self
    }
}

extension PurchaseContentOperation: DataConvertible {
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
