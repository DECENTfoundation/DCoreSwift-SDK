import Foundation

public protocol CustomOperation: Operation {
    var id: CustomOperationType { get }
    var payee: ChainObject { get }
    var requiredAuths: [ChainObject] { get }
    var data: String { get }
}

extension CustomOperation {
    public var type: OperationType { return .customOperation }
}
