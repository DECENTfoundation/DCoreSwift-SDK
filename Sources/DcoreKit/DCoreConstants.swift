import Foundation
import BigInt

extension DCore {
    
    public enum Constant {
        
        public enum Api {
            public static var timeout: TimeInterval = 30 // seconds
        }
        
        public enum Default {
            public static var expiration: Int = 30 // seconds
            public static var dct: ChainObject = "1.3.0".chain.chainObject!
        }
    }
}
