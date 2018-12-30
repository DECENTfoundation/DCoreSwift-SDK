import Foundation

public struct Account: Codable {
    
    public let id: ChainObject
    public let registrar: ChainObject
    public let name: String
    public let owner: Authority
    public let active: Authority
    public let options: Options
    public let rightsToPublish: Publishing
    public let statistics: ChainObject
    public let topControlFlags: Int
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        registrar,
        name,
        owner,
        active,
        options,
        rightsToPublish = "rights_to_publish",
        statistics,
        topControlFlags = "top_n_control_flags"
    }
    
    static func hasValid(name: String) -> Bool {
        return !name.matches(regex: "^[a-z][a-z0-9-]+[a-z0-9](?:\\.[a-z][a-z0-9-]+[a-z0-9])*\\$").isEmpty && (5...63).contains(name.count)
    }
}

extension Account {
    public typealias Reference = String
}
