import Foundation

public enum ChainError: Error {
    case unknown
    case notFound
    case addressFormat(String)
    case runtime(String)
    case underlying(Error)
}
