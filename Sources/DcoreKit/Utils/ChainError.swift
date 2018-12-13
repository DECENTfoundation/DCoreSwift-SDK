import Foundation

public enum ChainError: Error {
    case unknown
    case notFound
    case addressFormat(String)
    case illegal(String)
    case underlying(Error)
}
