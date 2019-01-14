import Foundation

extension Error {
    func asChainException() -> ChainException {
        return ChainException(from: self)
    }
}
