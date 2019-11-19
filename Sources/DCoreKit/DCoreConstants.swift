import Foundation
import BigInt

extension DCore {
    
    /// Constants
    public enum Constant {
        
        public static let timeout: TimeInterval = 30 // seconds
        public static let expiration: Int = 30 // seconds
        public static let dct: ChainObject = "1.3.0".dcore.chainObject!
        public static let dctQrPrefix = "decent"
        public static let brainKeyWordCount = 16
        public static let maxShareSupply: Int64 = 7319777577456890
        public static let maxAssetPrecision = 12
        public static let uiaDescriptionMaxChars = 1000
        public static let nftNameMaxChars = 32
    }
    
    /// Limitations
    public enum Limits {
        public static let account: Int = 1000
        public static let asset: Int = 100
        public static let content: Int = 100
        public static let publisher: Int = 100
        public static let subscriber: Int = 100
        public static let seeders: Int = 100
        public static let purchase: Int = 100
        public static let messaging: Int = 1000
        public static let nft: Int = 100
    }
}
