import Foundation

protocol SecurityProvider: AnyObject {
    var validator: ServerTrustValidation? { get }
}
