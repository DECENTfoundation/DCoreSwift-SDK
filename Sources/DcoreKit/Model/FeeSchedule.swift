import Foundation

public struct FeeSchedule: Codable {
    
    public let parameters: [OperationType: FeeParameter]
    public let scale: UInt64
    
    private enum CodingKeys: String, CodingKey {
        case
        parameters,
        scale
    }
}
