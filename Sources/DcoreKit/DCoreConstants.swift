import Foundation
import BigInt

extension DCore {
    
    public enum Constant {
        
        public static var timeout: TimeInterval = 30 // seconds
        public static var expiration: Int = 30 // seconds
        public static var datePattern: String = "yyyy-MM-dd'T'HH:mm:ss"
        public static var dct: ChainObject = "1.3.0".chain.chainObject!
    }
}
