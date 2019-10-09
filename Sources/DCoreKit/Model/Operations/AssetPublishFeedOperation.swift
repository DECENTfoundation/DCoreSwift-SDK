import Foundation
import BigInt

public struct AssetPublishFeedOperation: Operation {
    
    public var publisher: ChainObject {
        willSet { precondition(publisher.objectType == .accountObject, "not a valid account object id") }
    }
    public var assetId: ChainObject {
        willSet { precondition(assetId.objectType == .assetObject, "not a valid asset object id") }
    }
    public var feed: Asset.MonitoredAssetOptions.PriceFeed
    
    public let type: OperationType = .assetPublishFeedOperation
    public var fee: AssetAmount  = .unset
    
    private enum CodingKeys: String, CodingKey {
        case
        publisher,
        assetId = "asset_id",
        feed,
        fee
    }
}

extension AssetPublishFeedOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> AssetPublishFeedOperation {
        return self
    }
}

extension AssetPublishFeedOperation {
    public func asData() -> Data {
        // TODO: Test and fix this method if necessary
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += publisher.asData()
        data += assetId.asData()
        data += feed.coreExchangeRate.asData()
        
        DCore.Logger.debug(crypto: "AssetPublishFeedOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
