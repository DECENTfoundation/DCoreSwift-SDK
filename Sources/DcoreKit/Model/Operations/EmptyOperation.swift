import Foundation

public final class EmptyOperation: BaseOperation {
    public var serialized: Data {
        return Data(count: 1)
    }
}
