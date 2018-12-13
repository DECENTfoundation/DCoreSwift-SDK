import Foundation
import RxSwift

public extension Single {
    public func cache(size: Int = 1) -> PrimitiveSequence<SingleTrait, Element> {
        return self.asObservable().share(replay: size).asSingle()
    }
}


public protocol URLTransform {
    func toURL() -> URL?
}

extension URL: URLTransform {
    public func toURL() -> URL? {
        return self
    }
}

extension String: URLTransform {
    public func toURL() -> URL? {
        return URL(string: self)
    }
}

public extension String {
    
    // Copyright: https://github.com/SwifterSwift/SwifterSwift
    
    public subscript(safe range: CountableRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex..<upperIndex])
    }
    
    // Copyright: https://github.com/SwifterSwift/SwifterSwift
    
    public subscript(safe range: ClosedRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex..<upperIndex])
    }
}


public extension Sequence where Element: Equatable {

    public func chunked(_ size: Int) -> [[Element]] {
        return self.reduce(into:[]) { memo, cur in
            if memo.count == 0 {
                return memo.append([cur])
            }
            if memo.last!.count < size {
                memo.append(memo.removeLast() + [cur])
            } else {
                memo.append([cur])
            }
        }
    }
}
