import Foundation

extension IntegerLiteralType {
    func limited(by max: IntegerLiteralType) throws -> IntegerLiteralType {
        guard self <= max else {
            throw DCoreException.unexpected("Limit is out of bound: \(max)")
        }
        return self
    }
}
