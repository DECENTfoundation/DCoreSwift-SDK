/**
 *
 * Original version: https://github.com/NeoTeo/VarInt
 *
 * This code provides "varint" encoding of 64-bit integers.
 * It is based on the Go implementation of the Google Protocol Buffers varint specification.
 *
 */

import Foundation

extension UInt64 {
    func asUnsignedVarIntBytes() -> [UInt8] {
        var buffer = [UInt8]()
        var val: UInt64 = self
        
        while val >= 0x80 {
            buffer.append((UInt8(truncatingIfNeeded: val) | 0x80))
            val >>= 7
        }
        
        buffer.append(UInt8(val))
        return buffer
    }
    
    func asUnsignedVarIntData() -> Data {
        return Data(asUnsignedVarIntBytes())
    }
}

extension Int64 {
    func asVarIntBytes() -> [UInt8] {
        let value = UInt64(self) << 1
        return value.asUnsignedVarIntBytes()
    }
    
    func asVarIntData() -> Data {
        return Data(asVarIntBytes())
    }
}

extension Sequence where Element == UInt8 {
    func asUnsignedVarInt() -> (UInt64, Int) {
        var output: UInt64 = 0
        var counter = 0
        var shifter: UInt64 = 0
        
        for byte in self {
            if byte < 0x80 {
                if counter > 9 || counter == 9 && byte > 1 {
                    return (0, -(counter + 1))
                }
                return (output | UInt64(byte) << shifter, counter+1)
            }
            
            output |= UInt64(byte & 0x7f) << shifter
            shifter += 7
            counter += 1
        }
        return (0, 0)
    }
    
    func asVarInt() -> (Int64, Int) {
        let (unsignedValue, bytesRead)  = self.asUnsignedVarInt()
        var value = Int64(unsignedValue >> 1)
        
        if unsignedValue & 1 != 0 { value = ~value }
        
        return (value, bytesRead)
    }
}

extension InputStream {
    func asUnsignedVarInt() throws -> UInt64 {
        var value: UInt64   = 0
        var shifter: UInt64 = 0
        var index = 0
        
        repeat {
            var buffer = [UInt8](repeating: 0, count: 10)
            
            if self.read(&buffer, maxLength: 1) < 0 {
                throw DCoreException.unexpected("Read invalid stream")
            }
            
            let buf = buffer[0]
            
            if buf < 0x80 {
                if index > 9 || index == 9 && buf > 1 {
                    throw DCoreException.unexpected("Input stream overflow")
                }
                return value | UInt64(buf) << shifter
            }
            value |= UInt64(buf & 0x7f) << shifter
            shifter += 7
            index += 1
        } while true
    }
    
    func asVarInt() throws -> Int64 {
        let unsignedValue = try asUnsignedVarInt()
        var value = Int64(unsignedValue >> 1)
        
        if unsignedValue & 1 != 0 {
            value = ~value
        }
        
        return value
    }
}
