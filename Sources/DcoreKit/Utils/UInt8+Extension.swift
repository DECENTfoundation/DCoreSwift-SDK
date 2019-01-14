import Foundation

extension UInt8 {
    
    static func with(value: UInt64) -> UInt8 {
        let tmp = value & 0xff
        return UInt8(tmp)
    }
    
    static func with(value: UInt32) -> UInt8 {
        let tmp = value & 0xff
        return UInt8(tmp)
    }
    
    static func with(value: UInt16) -> UInt8 {
        let tmp = value & 0xff
        return UInt8(tmp)
    }
}
