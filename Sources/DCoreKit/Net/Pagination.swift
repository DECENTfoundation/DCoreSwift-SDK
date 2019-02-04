import Foundation

extension UInt64 {
    fileprivate static let unset: UInt64 = 0
}

public enum Pagination: Equatable {
    
    public static let ignore: Pagination = .page(bounds: .unset..<(.unset), offset: .unset, limit: 1000)
    public static let ignoreObject: Pagination = .pageObject(bounds: ObjectType.unset..<(ObjectType.unset), limit: 100)
    
    case
    pageObject(bounds: Range<ChainObject>, limit: UInt64),
    page(bounds: Range<UInt64>, offset: UInt64, limit: UInt64)
}
