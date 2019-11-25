import Foundation

public protocol ObjectIdConvertible {
    func asObjectId<T: ObjectId>() throws -> T
}

extension ObjectId: ObjectIdConvertible {
    public func asObjectId<T: ObjectId>() throws -> T { try T(from: asString()) }
}

extension String: ObjectIdConvertible {
    public func asObjectId<T: ObjectId>() throws -> T {
        return try dcore.objectId().orThrow(
            DCoreException.unexpected("Object Id invalid format")
        )
    }
}

public protocol AccountObjectIdConvertible: ObjectIdConvertible {
    func asAccountObjectId() throws -> AccountObjectId
}

extension AccountObjectIdConvertible {
    public func asAccountObjectId() throws -> AccountObjectId {
        return try asObjectId()
    }
}

extension AccountObjectId: AccountObjectIdConvertible {}

extension String: AccountObjectIdConvertible {}

public protocol AssetObjectIdConvertible: ObjectIdConvertible {
    func asAssetObjectId() throws -> AssetObjectId
}

extension AssetObjectIdConvertible {
    public func asAssetObjectId() throws -> AssetObjectId {
        return try asObjectId()
    }
}

extension AssetObjectId: AssetObjectIdConvertible {}

extension String: AssetObjectIdConvertible {}
