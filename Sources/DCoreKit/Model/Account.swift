import Foundation

public struct Account: Codable {
    
    public let id: AccountObjectId
    public let registrar: AccountObjectId
    public let name: String
    public let owner: Authority
    public let active: Authority
    public let options: Options
    public let rightsToPublish: Publishing
    public let statistics: AccountStatsObjectId
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
    
    public static func hasValid(name: String) -> Bool {
        return !name.matches(regex: "^(?=.{5,63}$)([a-z][a-z0-9-]+[a-z0-9])(\\.[a-z][a-z0-9-]+[a-z0-9])*$").isEmpty
    }
}

extension Account: Equatable {
    public static func == (lhs: Account, rhs: Account) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Account {
    public typealias Reference = String
}
