import Foundation

extension UInt64 {
    fileprivate static let zero: UInt64 = 0
}

public enum Pagination: Equatable {
    
    public static let ignore: Pagination = .page(bounds: .zero..<(.zero), offset: .zero, limit: 100)
    public static let ignoreObject: Pagination = .pageObject(bounds: ObjectType.ignore..<(ObjectType.ignore), limit: 100)
    
    case
    pageObject(bounds: Range<ChainObject>, limit: UInt64),
    page(bounds: Range<UInt64>, offset: UInt64, limit: UInt64)
}
