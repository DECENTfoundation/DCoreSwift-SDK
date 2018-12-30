import Foundation

public enum DCoreError: Error {
    
    case failure(Any)
    case notFound(String)
    case illegal(String)
    case underlying(Error)
}
