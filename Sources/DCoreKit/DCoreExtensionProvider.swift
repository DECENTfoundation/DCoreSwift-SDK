import Foundation

public protocol DCoreExtensionProvider {}

extension DCoreExtensionProvider {
    public var dcore: DCoreExtension<Self> {
        return DCoreExtension(self)
    }
    
    public static var dcore: DCoreExtension<Self>.Type {
        return DCoreExtension<Self>.self
    }
}

public struct DCoreExtension<Base> {
    public let base: Base
    
    fileprivate init(_ base: Base) {
        self.base = base
    }
}
