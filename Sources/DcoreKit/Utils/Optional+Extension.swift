import Foundation

extension Optional {
    func isNil() -> Bool {
        if case .none = self { return true }
        return false
    }
}
