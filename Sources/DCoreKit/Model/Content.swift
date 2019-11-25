import Foundation

public struct Content: Codable {
    
    public let id: ContentObjectId
    public let author: String
    public let coAuthors: [Pair<AccountObjectId, Int>]?
    public let regionalPrice: PricePerRegion
    public let synopsisJson: String
    public let uri: String
    public let hash: String
    public let rating: Int
    public let size: UInt64
    public let expiration: Date
    public let created: Date
    public let timesBought: Int
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        author,
        coAuthors = "co_authors",
        regionalPrice = "price",
        synopsisJson = "synopsis",
        uri = "URI",
        hash = "_hash",
        rating = "AVG_rating",
        size,
        expiration,
        created,
        timesBought = "times_bought"
    }
    
    public var price: AssetAmount {
        guard let value = regionalPrice.prices[Regions.none.id] else {
            preconditionFailure("Region price does not exist")
        }
        return value
    }

    public func synopsis<S: SynopsisConvertible>() throws -> S? {
        return try JSONDecoder().decode(S.self, from: synopsisJson.data(using: .utf8)!)
    }
    
    static func hasValid(uri: String) -> Bool {
        return !uri.matches(regex: "^(https?|ipfs|magnet):.*").isEmpty
    }
}

extension Content {
    public typealias Reference = String
}

extension Content {
    func modifiedSubmitContent<Input>(
        by newSynopsis: Input? = nil,
        newPrice: AssetAmount? = nil,
        newCoAuthors: [Pair<AccountObjectId, Int>]? = nil
    ) throws -> SubmitContent<Input> where Input: SynopsisConvertible {
        guard let updatedSynopsis: Input = try newSynopsis ?? synopsis() else {
            throw DCoreException.unexpected("Unable to decode synopsis")
        }
        if let coAuths = newCoAuthors ?? coAuthors {
            return .cdnWithSharedPrice(
                url: uri,
                expiration: expiration,
                price: newPrice ?? price,
                synopsis: updatedSynopsis,
                coauthors: coAuths
            )
        } else if let price = newPrice {
            return .cdnWithPrice(url: uri, expiration: expiration, price: price, synopsis: updatedSynopsis)
        } else {
            return .cdn(url: uri, expiration: expiration, synopsis: updatedSynopsis)
        }
    }
}
