import Foundation

extension CaseIterable where Self: RawRepresentable {
    public static var first: Self? {
        return Self.allCases.first
    }
}

extension RawRepresentable where Self: CaseIterable & Equatable {
    public var offset: Int? {
        return Self.allCases.enumerated().first(where: { $0.element == self })?.offset
    }
}
