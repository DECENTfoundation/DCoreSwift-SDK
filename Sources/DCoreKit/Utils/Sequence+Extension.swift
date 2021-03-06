import Foundation

public extension Sequence where Element: Equatable {
    func chunked(_ size: Int) -> [[Element]] {
        return self.reduce(into: []) { memo, cur in
            if memo.isEmpty {
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
