import Foundation

extension DCore {
    
    public enum Constant {
        
        public enum Api {
            public static var jsonrpc: String = "2.0"
            public static var method: String = "call"
            public static var timeout: TimeInterval = 30 // seconds
            
            enum Group: String, CaseIterable {
                case
                database,
                login = "",
                broadcast = "network_broadcast",
                history,
                crypto,
                messaging
            }
        }
        
        public enum Default {
            public static var expiration: Int = 30 // seconds
            public static var dct: ChainObject = "1.3.0".chainObject
        }
        
        enum Symbol: String {
            case
            alxt = "ALXT",
            alat = "ALAT",
            alx = "ALX",
            aia = "AIA",
            dct = "DCT"
        }
    }
}
