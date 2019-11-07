import Foundation

public protocol ObjectIdConvertible {
    func asObjectId<T: ObjectId>() throws -> T
}

extension ObjectId: ObjectIdConvertible {
    public func asObjectId<T: ObjectId>() throws -> T {
        guard let objectId = self as? T else {
            throw DCoreException.unexpected("Failed to convert \(self) into \(T.self)")
        }
        return objectId
    }
}

extension String: ObjectIdConvertible {
    public func asObjectId<T: ObjectId>() throws -> T {
        return try dcore.objectId().orThrow(
            DCoreException.unexpected("Object Id invalid format")
        )
    }
}
