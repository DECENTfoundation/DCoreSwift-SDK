import Foundation

public protocol SecurityProvider: AnyObject {
    var validator: ServerTrustValidation? { get }
}
