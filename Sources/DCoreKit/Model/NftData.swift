/**
 Represents data of a NFT

 - Parameter id: Id of the data
 - Parameter nftId: Id of the NFT that this data belongs to
 - Parameter owner: Id of owner account of the NFT
 - Parameter data: Data of the NFT parsed as model specified by generic parameter
 */
public struct NftData<T: NftModel>: Codable {
    public let id: ChainObject
    public let nftId: ChainObject
    public let owner: ChainObject
    public let data: T?

    private enum CodingKeys: String, CodingKey {
        case
        id,
        nftId = "nft_id",
        owner,
        data
    }
}
