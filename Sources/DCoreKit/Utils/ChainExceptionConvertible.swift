import Foundation

public extension Error {
    func asChainException() -> ChainException {
        return ChainException(from: self)
    }
}
