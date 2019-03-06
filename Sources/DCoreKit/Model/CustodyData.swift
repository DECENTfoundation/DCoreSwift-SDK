import Foundation

public struct CustodyData: Codable {
    
    public let signatureCount: Int
    public let uSeed: String // Fixed size 16
    public let pubKey: String
    
    private enum CodingKeys: String, CodingKey {
        case
        signatureCount = "n",
        uSeed = "u_seed",
        pubKey
    }
}

extension CustodyData: DataConvertible {
    public func asData() -> Data {
        var data = Data()
        data += signatureCount.littleEndian
        data += Data(count: 16)
        data += Data(count: 33)
        
        DCore.Logger.debug(crypto: "CustodyData binary: %{private}s", args: { "\(data.toHex()) (\(data)) \(data.bytes)"})
        return data
    }
}
