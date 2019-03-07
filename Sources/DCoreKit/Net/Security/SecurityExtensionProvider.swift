import Foundation

public protocol SecurityExtensionProvider {}

extension SecurityExtensionProvider {
    public var security: SecurityExtension<Self> {
        return SecurityExtension(self)
    }
}

public struct SecurityExtension<Base> {
    public let base: Base
    
    fileprivate init(_ base: Base) {
        self.base = base
    }
}
