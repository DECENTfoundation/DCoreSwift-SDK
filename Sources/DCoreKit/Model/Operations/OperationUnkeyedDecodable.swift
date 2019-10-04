import Foundation

protocol OperationUnkeyedDecodable {
    static func decodeUnkeyed(from container: UnkeyedDecodingContainer) throws -> Operation
}

extension OperationUnkeyedDecodable {
    static func decodeUnkeyed(from container: UnkeyedDecodingContainer) throws -> Operation {
        var unkeyed = container
        
        let type = try unkeyed.decode(OperationType.self)
        switch type {
        case .transferOperation, .transferTwoOperation:
            var operation = try unkeyed.decode(TransferOperation.self)
            operation.mutableType = type
            return operation
        case .contentSubmitOperation:
            return try unkeyed.decode(SubmitContentOperation.self)
        case .contentCancellationOperation:
            return try unkeyed.decode(CancelContentOperation.self)
        case .requestToBuyOperation:
            return try unkeyed.decode(PurchaseContentOperation.self)
        case .accountCreateOperation:
            return try unkeyed.decode(AccountCreateOperation.self)
        case .accountUpdateOperation:
            return try unkeyed.decode(AccountUpdateOperation.self)
        case .customOperation:
            return try unkeyed.decode(AnyCustomOperation.self)
        case .assetCreateOperation:
            return try unkeyed.decode(AssetCreateOperation.self)
        case .assetIssueOperation:
            return try unkeyed.decode(AssetIssueOperation.self)
        case .assetPublishFeedOperation:
            return try unkeyed.decode(AssetPublishFeedOperation.self)
        case .assetFundPoolsOperation:
            return try unkeyed.decode(AssetFundPoolsOperation.self)
        case .assetReserveOperation:
            return try unkeyed.decode(AssetReserveOperation.self)
        case .assetClaimFeesOperation:
            return try unkeyed.decode(AssetClaimFeesOperation.self)
        case .updateUserIssuedAssetAdvancedOperation:
            return try unkeyed.decode(AssetUpdateAdvancedOperation.self)
        default:
            return try unkeyed.decode(UnknownOperation.self)
        }
    }
}
