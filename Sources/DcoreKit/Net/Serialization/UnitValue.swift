import Foundation

// Conforming Void to Decodable is not possible. Void is just a type alias for an empty tuple, (),
// and tuples cannot conform to protocols at this moment, but they will, eventually.

enum UnitValue: Codable {
 
    case Void
    
    public init(from decoder: Decoder) throws {
        self = .Void
    }
    
    public func encode(to encoder: Encoder) throws {
        fatalError("Not implemented")
    }
}
