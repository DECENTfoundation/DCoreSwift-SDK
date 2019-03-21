public struct Pair<A, B> {
    public let first: A
    public let second: B

    public init(_ first: A, _ second: B) {
        self.first = first
        self.second = second
    }
}

extension Pair: Codable where A: Codable, B: Codable {
    public init(from decoder: Decoder) throws {
        var unkeyed = try decoder.unkeyedContainer()
        self.init(try unkeyed.decode(A.self),
                  try unkeyed.decode(B.self))
    }
    
    public func encode(to encoder: Encoder) throws {
        var unkeyed = encoder.unkeyedContainer()
        try unkeyed.encode(first)
        try unkeyed.encode(second)
    }
}
