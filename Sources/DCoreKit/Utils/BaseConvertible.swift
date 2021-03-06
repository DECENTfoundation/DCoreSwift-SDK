//
//  Copyright © 2018 Kishikawa Katsumi
//  Copyright © 2018 BitcoinKit developers
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

private protocol BaseConvertible {
    
    static var baseAlphabets: String { get }
    static var zeroAlphabet: Character { get }
    static var base: Int { get }
    
    // log(256) / log(base), rounded up
    static func sizeFromByte(size: Int) -> Int
    // log(base) / log(256), rounded up
    static func sizeFromBase(size: Int) -> Int
    
    static func encode(_ bytes: Data) -> String
    static func decode(_ string: String) -> Data?
}

// The Base encoding used is home made, and has some differences. Especially,
// leading zeros are kept as single zeros when conversion happens.
extension BaseConvertible {
    
    static func convertBytesToBase(_ bytes: Data) -> [UInt8] {
        
        var length = 0
        let size = sizeFromByte(size: bytes.count)
        var encodedBytes: [UInt8] = Array(repeating: 0, count: size)
        
        for byte in bytes {
            var carry = Int(byte)
            var index = 0
            for encodedIndex in (0...encodedBytes.count - 1).reversed() where carry != 0 || index < length {
                carry += 256 * Int(encodedBytes[encodedIndex])
                encodedBytes[encodedIndex] = UInt8(carry % base)
                carry /= base
                index += 1
            }
            
            assert(carry == 0)
            
            length = index
        }
        
        var zerosToRemove = 0
        for byte in encodedBytes {
            if byte != 0 { break }
            zerosToRemove += 1
        }
        
        encodedBytes.removeFirst(zerosToRemove)
        return encodedBytes
    }
    
    static func encode(_ bytes: Data) -> String {
        
        var bytes = bytes
        var zerosCount = 0
        
        for byte in bytes {
            if byte != 0 { break }
            zerosCount += 1
        }
        
        bytes.removeFirst(zerosCount)
        
        let encodedBytes = convertBytesToBase(bytes)
        
        var str = ""
        while 0 < zerosCount {
            str += String(zeroAlphabet)
            zerosCount -= 1
        }
        
        for byte in encodedBytes {
            str += String(baseAlphabets[String.Index(utf16Offset: Int(byte), in: baseAlphabets)])
        }
        
        return str
    }
    
    static func decode(_ string: String) -> Data? {
        
        guard !string.isEmpty else { return nil }
        
        var zerosCount = 0
        var length = 0
        for char in string {
            if char != zeroAlphabet { break }
            zerosCount += 1
        }
        let size = sizeFromBase(size: string.lengthOfBytes(using: .utf8) - zerosCount)
        var decodedBytes: [UInt8] = Array(repeating: 0, count: size)
        for char in string {
            guard let baseIndex = baseAlphabets.firstIndex(of: char) else { return nil }
            
            var carry = baseIndex.utf16Offset(in: string)
            var index = 0
            for decodedIndex in (0...decodedBytes.count - 1).reversed() where carry != 0 || index < length {
                carry += base * Int(decodedBytes[decodedIndex])
                decodedBytes[decodedIndex] = UInt8(carry % 256)
                carry /= 256
                index += 1
            }
            
            assert(carry == 0)
            length = index
        }
        
        // skip leading zeros
        var zerosToRemove = 0
        
        for byte in decodedBytes {
            if byte != 0 { break }
            zerosToRemove += 1
        }
        decodedBytes.removeFirst(zerosToRemove)
        
        return Data(repeating: 0, count: zerosCount) + Data(decodedBytes)
    }
}

public struct Base58 {
    
    private struct BaseCoder: BaseConvertible {
        
        static let baseAlphabets = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
        static var zeroAlphabet: Character = "1"
        static var base: Int = 58
        
        static func sizeFromByte(size: Int) -> Int {
            return size * 138 / 100 + 1
        }
        static func sizeFromBase(size: Int) -> Int {
            return size * 733 / 1000 + 1
        }
    }
    
    public static func encode(_ bytes: Data) -> String {
        return BaseCoder.encode(bytes)
    }

    public static func decode(_ value: String) -> Data? {
        return BaseCoder.decode(value)
    }
}
