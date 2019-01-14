import Foundation

public struct CustodyData: Codable {
    
    public let signatureCount: Int
    public let uSeed: [UInt16] // Fixed size 16
    public let pubKey: UInt64
    
    private enum CodingKeys: String, CodingKey {
        case
        signatureCount = "n",
        uSeed = "u_seed",
        pubKey
    }
}

extension CustodyData: DataSerializable {
    public var serialized: Data {
        var data = Data()
        data += signatureCount
        data += Data(count: 16)
        data += Data(count: 33)
        return data
    }
}
