import Foundation
import BigInt

extension JSONDecoder {
    public static func codingContext() -> JSONDecoder {
        return JSONDecoder(context: [
            BigInt.CodingContext.key: BigInt.CodingContext.decimal
            ])
    }
    
    convenience init(context: [CodingUserInfoKey: Any]) {
        
        self.init()
        self.userInfo = context
        self.dateDecodingStrategy = .formatted(DateFormatter.standard)
    }
}

extension JSONEncoder {
    public static func codingContext() -> JSONEncoder {
        return JSONEncoder(context: [
            BigInt.CodingContext.key: BigInt.CodingContext.decimal
            ])
    }
    
    convenience init(context: [CodingUserInfoKey: Any]) {
        self.init()
        self.userInfo = context
        self.dateEncodingStrategy = .formatted(DateFormatter.standard)
    }
}
