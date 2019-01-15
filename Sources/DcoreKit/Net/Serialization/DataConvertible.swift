import Foundation
import BigInt

// swiftlint:disable shorthand_operator

protocol DataConvertible {
    static func + (lhs: Data, rhs: Self) -> Data
    static func += (lhs: inout Data, rhs: Self)
    
    func asData() -> Data
}

extension DataConvertible {
    static func + (lhs: Data, rhs: Self) -> Data {
        var value = rhs
        let data = Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
        return lhs + data
    }
    
    static func += (lhs: inout Data, rhs: Self) {
        lhs = lhs + rhs
    }
    
    func asData() -> Data { fatalError("Missing override: \(self)") }
}

extension UInt8: DataConvertible {}
extension UInt16: DataConvertible {}
extension UInt32: DataConvertible {}
extension UInt64: DataConvertible {}
extension Int8: DataConvertible {}
extension Int16: DataConvertible {}
extension Int32: DataConvertible {}
extension Int64: DataConvertible {}
extension Int: DataConvertible {}

extension BigInt: DataConvertible {
    static func + (lhs: Data, rhs: BigInt) -> Data {
        return lhs + rhs.magnitude.serialize()
    }
    
    static func += (lhs: inout Data, rhs: BigInt) {
        lhs = lhs + rhs.magnitude.serialize()
    }
    
    func asData() -> Data { return self.magnitude.serialize() }
}

extension Array where Element: DataConvertible {
    static func + (lhs: Data, rhs: Array) -> Data {
        return lhs + rhs.reduce(into: Data(), { data, element in
            data = data + element
        })
    }
    
    static func += (lhs: inout Data, rhs: Array) {
        lhs = lhs + rhs.reduce(into: Data(), { data, element in
            data = data + element
        })
    }
}

extension Set where Element: DataConvertible {
    static func + (lhs: Data, rhs: Set) -> Data {
        return lhs + rhs.reduce(into: Data(), { data, element in
            data = data + element
        })
    }
    
    static func += (lhs: inout Data, rhs: Set) {
        lhs = lhs + rhs.reduce(into: Data(), { data, element in
            data = data + element
        })
    }
}

extension Bool: DataConvertible {
    static func + (lhs: Data, rhs: Bool) -> Data {
        return lhs + (rhs ? UInt8(0x01) : UInt8(0x00)).littleEndian
    }
}

extension String: DataConvertible {
    static func + (lhs: Data, rhs: String) -> Data {
        guard let data = rhs.data(using: .ascii) else { return lhs }
        return lhs + data
    }
    
    func asData() -> Data {
        return data(using: .utf8) ?? Data(count: 0)
    }
}

extension Data: DataConvertible {
    static func + (lhs: Data, rhs: Data) -> Data {
        var data = Data()
        data.append(lhs)
        data.append(rhs)
        return data
    }
    
    func asData() -> Data { return self }
}

extension Data {
    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.pointee }
    }
    
    func to(type: String.Type) -> String {
        return String(bytes: self, encoding: .ascii)!.replacingOccurrences(of: "\0", with: "")
    }
    
    func to(type: VarInt.Type) -> VarInt {
        let value: UInt64
        let length = self[0..<1].to(type: UInt8.self)
        
        switch length {
        case 0...252:
            value = UInt64(length)
        case 0xfd:
            value = UInt64(self[1...2].to(type: UInt16.self))
        case 0xfe:
            value = UInt64(self[1...4].to(type: UInt32.self))
        case 0xff:
            fallthrough // swiftlint:disable:this no_fallthrough_only
        default:
            value = self[1...8].to(type: UInt64.self)
        }
        return VarInt(value)
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
    public func unhex() -> Data? {
        return Data(hex: self)
    }
}
