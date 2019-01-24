import Foundation

struct AnyEncodable: Encodable {
    
    private let encodable: Encodable
    
    init(_ encodable: Encodable) {
        self.encodable = encodable
    }
    
    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}

struct AnyCodable: Codable {
    
    private let encodable: Codable
    
    init(_ encodable: Codable) {
        self.encodable = encodable
    }
    
    init(from decoder: Decoder) throws {
        fatalError("")
    }
    
    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
