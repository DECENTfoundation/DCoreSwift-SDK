import Foundation

public protocol ChainProvider {}

extension ChainProvider {
    public var chain: Chain<Self> {
        return Chain(self)
    }
    
    public static var core: Chain<Self>.Type {
        return Chain<Self>.self
    }
}

public struct Chain<Base> {
    public let base: Base
    
    fileprivate init(_ base: Base) {
        self.base = base
    }
}
