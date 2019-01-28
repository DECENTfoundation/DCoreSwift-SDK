import Foundation

public extension Error {
    func asDCoreException() -> DCoreException {
        return DCoreException(from: self)
    }
}
