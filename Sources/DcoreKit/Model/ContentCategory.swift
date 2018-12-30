import Foundation


public enum ContentCategory {

    public enum Application: Int, Codable {
        case
        DECENT_CORE = 0,
        DECENT_GO,
        ALAX
    }
    
    public enum Category: Int, Codable {
        case
        NONE = 0,
        MUSIC,
        MOVIE,
        BOOK,
        AUDIO_BOOK,
        SOFTWARE,
        GAME,
        PICTURE,
        DOCUMENT
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
