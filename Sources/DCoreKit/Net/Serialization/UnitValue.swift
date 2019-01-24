import Foundation

// Conforming Void to Decodable is not possible. Void is just a type alias for an empty tuple, (),
// and tuples cannot conform to protocols at this moment, but they will, eventually.

public enum UnitValue: Codable {
 
    case void
    
    public init(from decoder: Decoder) throws {
        self = .void
    }
    
    public func encode(to encoder: Encoder) throws {
        fatalError("Not implemented")
    }
}
