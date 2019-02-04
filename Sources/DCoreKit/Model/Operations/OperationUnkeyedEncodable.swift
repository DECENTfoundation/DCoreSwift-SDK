import Foundation

public protocol OperationUnkeyedEncodable {
    func encodeUnkeyed(to encoder: Encoder) throws
}

extension OperationUnkeyedEncodable where Self: Operation {
    public func encodeUnkeyed(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
     
        try container.encode(type)
        try container.encode(AnyEncodable(self))
    }
}
