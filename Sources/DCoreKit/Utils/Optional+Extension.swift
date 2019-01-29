import Foundation

extension Optional {
    public func isNil() -> Bool {
        if case .none = self { return true }
        return false
    }
    
    public func or(_ other: Wrapped) -> Wrapped {
        if let ret = self {
            return ret
        } else {
            return other
        }
    }
    
    public func orThrow(_ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            throw errorExpression()
        }
        return value
    }
}

extension Optional where Wrapped == String {
    func isEmptyOrNil() -> Bool {
        guard !isNil() else { return true }
        return self.unsafelyUnwrapped.isEmpty
    }
}
