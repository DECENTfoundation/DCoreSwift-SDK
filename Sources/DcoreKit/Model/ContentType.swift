import Foundation


public enum ContentType: CustomStringConvertible {
    
    case id(Application, Category)
    
    public var description: String {
        switch self {
        case .id(let app, let category): return  "\(app.rawValue).\(category.rawValue).0"
        }
    }
    
    public enum Application: Int {
        case
        DECENT_CORE,
        DECENT_GO,
        ALAX
    }
    
    public enum Category: Int {
        case
        NONE,
        MUSIC,
        MOVIE,
        BOOK,
        AUDIO_BOOK,
        SOFTWARE,
        GAME,
        PICTURE,
        DOCUMENT
    }
}
