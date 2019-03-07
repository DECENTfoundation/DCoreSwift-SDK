import Foundation

protocol SecurityConfigurable {
    func secured(by validator: ServerTrustValidation?)
}
