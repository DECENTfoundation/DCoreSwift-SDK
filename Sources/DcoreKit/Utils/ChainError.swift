import Foundation

public enum ChainError: Error {
    case notFound(String)
    case runtime(Any)
    case addressFormat(String)
    case illegal(String)
    case underlying(Error)
}
