import Foundation
import BigInt

extension JSONDecoder {
    static func codingContext() -> JSONDecoder {
        return JSONDecoder(context: [
            BigInt.CodingContext.key: BigInt.CodingContext.decimal
        ])
    }
    
    convenience init(context: [CodingUserInfoKey: Any]) {
        self.init()
        self.userInfo = context
    }
}

extension JSONEncoder {
    static func codingContext() -> JSONEncoder {
        return JSONEncoder(context: [
            BigInt.CodingContext.key: BigInt.CodingContext.decimal
            ])
    }
    
    convenience init(context: [CodingUserInfoKey: Any]) {
        self.init()
        self.userInfo = context
    }
}
