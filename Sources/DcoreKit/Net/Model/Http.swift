import Foundation

public enum Http {
    
    public enum Header {
    
        public enum ContentType: String {
            
            case
            applicationJson = "application/json; charset=UTF-8"
        }
        
        public static func contentType(_ value: ContentType) -> Header {
            return Header.fieldPair("Content-Type", value.rawValue)
        }
        
        case
        field(String),
        fieldPair(String, String)
    }
    
    public enum Method: String {
        case
        post = "POST",
        get = "GET"
    }
    
    case
    header(Header),
    method(Method)
}

extension Http: CustomStringConvertible {
    public var description: String {
        switch self {
        case .header(let value): return value.description
        case .method(let value): return value.rawValue
        }
    }
}

extension Http.Header: CustomStringConvertible {
    public var description: String {
        fatalError()
    }
}
