import Foundation

extension Optional {
    func isNil() -> Bool {
        if case .none = self { return true }
        return false
    }
    
    func or(_ other: Wrapped) -> Wrapped {
        if let ret = self {
            return ret
        } else {
            return other
        }
    }
    
    func orThrow(_ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            throw errorExpression()
        }
        return value
    }
}
