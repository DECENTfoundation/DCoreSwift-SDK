import Foundation

public struct ChainProperties: Codable {
    
    public var id: ChainObject
    public var chainId: String
    public var parameters: ChainParameters
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        chainId = "chain_id",
        parameters = "immutable_parameters"
    }
}
