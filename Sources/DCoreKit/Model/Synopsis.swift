import Foundation

public struct Synopsis: SynopsisConvertible {
    
    public let title: String
    public let description: String
    public let type: ChainObject
    
    public init(title: String,
                description: String,
                type: ChainObject = ContentCategory.standard.objectId!) {
        self.title = title
        self.description = description
        self.type = type
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        title,
        description,
        type = "content_type_id"
    }
}

extension DCoreExtension where Base == String {
    func synopsis() -> Synopsis? {
        return try? JSONDecoder().decode(Synopsis.self, from: self.base.data(using: .utf8).or(Data.empty))
    }
}
