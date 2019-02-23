import Foundation
import BigInt

extension DCore {
    
    public enum Constant {
        
        public static let timeout: TimeInterval = 30 // seconds
        public static let expiration: Int = 30 // seconds
        public static let dct: ChainObject = "1.3.0".dcore.chainObject!
        public static let dctQrPrefix = "decent"
        public static let assetLimit: Int = 100 // max number of assets, that could be searched per one request
    }
}
