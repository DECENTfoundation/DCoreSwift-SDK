import Foundation
import BigInt

// swiftlint:disable shorthand_operator

public protocol DataEncodable {
    func asEncoded() -> Data
}

public protocol DataConvertible {
    func asData() -> Data
    func asOptionalData() -> Data
}

protocol DataConcatable {
    static func + (lhs: Data, rhs: Self) -> Data
    static func += (lhs: inout Data, rhs: Self)
}

extension DataConvertible {
    public func asData() -> Data {
        return Data.empty
    }
    
    public func asOptionalData() -> Data {
        return asData()
    }
}

extension DataConcatable {
    static func + (lhs: Data, rhs: Self) -> Data {
        var value = rhs
        let data = Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
        return lhs + data
    }
    
    static func += (lhs: inout Data, rhs: Self) {
        lhs = lhs + rhs
    }
}

extension DataEncodable {
    func asEncoded() -> Data {
        fatalError("Missing override \(self)")
    }
}

extension UInt8: DataConcatable {}
extension UInt16: DataConcatable {}
extension UInt32: DataConcatable {}
extension UInt64: DataConcatable {}
extension Int8: DataConcatable {}
extension Int16: DataConcatable {}
extension Int32: DataConcatable {}
extension Int64: DataConcatable {}
extension Int: DataConcatable {}

extension Data: DataConvertible, DataConcatable, DataEncodable {
   
    static func + (lhs: Data, rhs: Data) -> Data {
        var data = Data()
        data.append(lhs)
        data.append(rhs)
        return data
    }
    
    public func asData() -> Data {
        return UInt64(count).asUnsignedVarIntData() + self
    }
    
    public func asEncoded() -> Data {
        return self
    }
}

extension Bool: DataConvertible {
    public func asData() -> Data {
        return Data.of((self ? UInt8(0x01) : UInt8(0x00)).littleEndian)
    }
}

extension String: DataConvertible, DataConcatable, DataEncodable {
    static func + (lhs: Data, rhs: String) -> Data {
        return lhs + rhs.asData()
    }
    
    public func asData() -> Data {
        let bytes = data(using: .utf8).or(Data.ofZero)
        return UInt64(bytes.count).asUnsignedVarIntData() + bytes
    }
    
    public func asEncoded() -> Data {
        return data(using: .utf8).or(Data.empty)
    }
}

extension BigInt: DataConvertible, DataConcatable {
    static func + (lhs: Data, rhs: BigInt) -> Data {
        return lhs + rhs.asData()
    }
    
    static func += (lhs: inout Data, rhs: BigInt) {
        lhs = lhs + rhs.asData()
    }
    
    public func asData() -> Data {
        return Data(magnitude.serialize().reversed())
    }
}

extension Array where Element: DataConvertible {
    public func asData() -> Data {
        guard !isEmpty else { return Data.ofZero }
        return reduce(into: UInt64(count).asUnsignedVarIntData(), { data, element in
            data = data + element.asData()
        })
    }
}

extension Set where Element: DataConvertible {
    public func asData() -> Data {
        guard !isEmpty else { return Data.ofZero }
        return reduce(into: UInt64(count).asUnsignedVarIntData(), { data, element in
            data = data + element.asData()
        })
    }
}

extension Optional: DataConvertible where Wrapped: DataConvertible {

    public func asData() -> Data {
        guard let value = self else { return Data.ofZero }
        return value.asData()
    }
    
    public func asOptionalData() -> Data {
        guard let value = self else { return Data.ofZero }
        return Data.ofOne + value.asData()
    }
}

extension Optional where Wrapped == Address {
    
    public func asData() -> Data {
        guard let value = self else { return Data(count: 33) }
        return value.asData()
    }
}

extension Data {
    static var empty = Data(count: 0)
    
    static var ofZero = of(0)
    static var ofOne = of(1)
    
    static func of(_ byte: IntegerLiteralType) -> Data {
        return of([UInt8(byte)])
    }
    
    static func of(_ byte: UInt8) -> Data {
        return of([byte])
    }
    
    static func of(_ bytes: [UInt8]) -> Data {
        return Data(bytes)
    }
}

extension Data {
    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: type) }
    }
    
    func to(type: String.Type) -> String {
        return String(bytes: self, encoding: .utf8).or("")
    }
}

extension Data {
    public init?(hex: String) {
        let len = hex.count / 2
        var data = Data(capacity: len)
        for index in 0..<len {
            let minIndex = hex.index(hex.startIndex, offsetBy: index * 2)
            let maxIndex = hex.index(minIndex, offsetBy: 2)
            let bytes = hex[minIndex..<maxIndex]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
    
    public func toHex() -> String {
        return reduce("") { $0 + String(format: "%02x", $1) }
    }
}

extension String {
    public func unhex() -> Data? { return Data(hex: self) }
}

extension Substring {
    public func unhex() -> Data? { return String(self).unhex() }
}
