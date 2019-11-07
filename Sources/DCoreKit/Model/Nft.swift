import Foundation

/**
 General NFT data structure representing any NFT

 - Parameter id: NFT Object Id.
 - Parameter symbol: NFT symbol.
 - Parameter options: NFT options.
 - Parameter definitions: List of NFT property definitions.
 - Parameter transferable: allow transfer of NFT data instances to other accounts.
 - Parameter currentSupply: Current supply of this NFT.
 */

public struct Nft: Codable {
    let id: NftObjectId
    let symbol: String
    let options: NftOptions
    let definitions: [NftDataType]
    let transferable: Bool
    let currentSupply: UInt32

    private enum CodingKeys: String, CodingKey {
        case
        id,
        symbol,
        options,
        definitions,
        transferable,
        currentSupply = "current_supply"
    }
}

extension Nft {
    public typealias Reference = String
}
