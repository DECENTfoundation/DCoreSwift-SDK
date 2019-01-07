
import Foundation

public protocol CoreProvider {}

extension CoreProvider {
    public var core: Core<Self> {
        return Core(self)
    }
    
    public static var core: Core<Self>.Type {
        return Core<Self>.self
    }
}

public struct Core<Base> {
    public let base: Base
    
    fileprivate init(_ base: Base) {
        self.base = base
    }
}
