import Foundation

public protocol DataSerializable {
    var serialized: Data { get }
}

extension DataSerializable {
    public var serialized: Data {
        fatalError("Missing override: \(self)")
    }
}

extension DataSerializable {
    static func + (lhs: Data, rhs: Self) -> Data {
        return lhs + rhs.serialized
    }
    
    static func += (lhs: inout Data, rhs: Self) {
        lhs += rhs.serialized
    }
}

extension Array where Element: DataSerializable {
    static func + (lhs: Data, rhs: Array) -> Data {
        return lhs + rhs.reduce(into: Data(), { data, el in
            data += el
        })
    }
    
    static func += (lhs: inout Data, rhs: Array) {
        lhs += rhs.reduce(into: Data(), { data, el in
            data += el
        })
    }
}

extension Set where Element: DataSerializable {
    static func + (lhs: Data, rhs: Set) -> Data {
        return lhs + rhs.reduce(into: Data(), { data, el in
            data += el
        })
    }
    
    static func += (lhs: inout Data, rhs: Set) {
        lhs += rhs.reduce(into: Data(), { data, el in
            data += el
        })
    }
}
