import Foundation

extension Int {
    public var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<Int>.size)
    }
}

extension UInt8 {
    public var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt8>.size)
    }
}

extension UInt16 {
    public var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt16>.size)
    }
}

extension UInt32 {
    public var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt32>.size)
    }
    
    public var bytesAsLittleEndian: [UInt8] {
        return [
            UInt8((self & 0xFF000000) >> 24),
            UInt8((self & 0x00FF0000) >> 16),
            UInt8((self & 0x0000FF00) >> 8),
            UInt8(self & 0x000000FF)
        ]
    }
}

extension Data {
    
    public var uint8: UInt8 {
        var value: UInt8 = 0
        self.copyBytes(to:&value, count: MemoryLayout<UInt8>.size)
        return value
    }
    
    public var uint16: UInt16 {
        let i16array = self.withUnsafeBytes {
            UnsafeBufferPointer<UInt16>(start: $0, count: self.count/2).map(UInt16.init(littleEndian:))
        }
        return i16array[0]
    }
    
    public var uint32: UInt32 {
        let i32array = self.withUnsafeBytes {
            UnsafeBufferPointer<UInt32>(start: $0, count: self.count/2).map(UInt32.init(littleEndian:))
        }
        return i32array[0]
    }
}
