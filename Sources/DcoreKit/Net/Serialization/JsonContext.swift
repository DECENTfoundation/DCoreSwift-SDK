import Foundation
import BigInt

extension JSONDecoder {
    public static func codingContext(_ datePattern: String = DCore.Constant.datePattern) -> JSONDecoder {
        return JSONDecoder(context: [
            BigInt.CodingContext.key: BigInt.CodingContext.decimal
            ], datePattern: datePattern)
    }
    
    convenience init(context: [CodingUserInfoKey: Any], datePattern pattern: String) {
        let format = DateFormatter()
        format.dateFormat = pattern
        
        self.init()
        self.userInfo = context
        self.dateDecodingStrategy = .formatted(format)
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
    }
}
