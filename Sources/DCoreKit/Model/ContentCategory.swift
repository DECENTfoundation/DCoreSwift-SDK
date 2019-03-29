import Foundation

public enum ContentCategory {

    public static let standard: ContentCategory = .id(.decentCore, .none)
    
    public var objectId: ChainObject? {
         return self.description.dcore.chainObject
    }
    
    public enum Application: Int, Codable {
        case
        decentCore = 0,
        decentGo,
        alax
    }
    
    public enum Category: Int, Codable {
        case
        none = 0,
        music,
        movie,
        book,
        audioBook,
        software,
        game,
        picture,
        document
    }
    
    case id(Application, Category)
}

extension ContentCategory: CustomStringConvertible {
    public var description: String {
        switch self {
        case .id(let app, let category): return  "\(app.rawValue).\(category.rawValue).0"
        }
    }
}

extension ContentCategory: Codable {
    public init(from decoder: Decoder) throws {
        fatalError("Not Implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}
