import Foundation

public enum ChainError: Error {
    case unknown
    case runtime(String)
    case underlying(Error)
}
