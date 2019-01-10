import Foundation

// 0 - database
// 1 - login
// 2 - network/broadcast
// 3 - history
// 4 - crypto
// 5 - messaging

enum ApiGroup {
    
    static let database: ApiGroup =  ApiGroup(group: .database)
    static let login: ApiGroup =     ApiGroup(group: .login)
    static let broadcast: ApiGroup = ApiGroup(group: .broadcast)
    static let history: ApiGroup =   ApiGroup(group: .history)
    static let crypto: ApiGroup =    ApiGroup(group: .crypto)
    static let messaging: ApiGroup = ApiGroup(group: .messaging)

    private enum Category: String, CaseIterable {
        case
        database,
        login = "",
        broadcast = "network_broadcast",
        history,
        crypto,
        messaging
    }
    
    private init(group: Category) {
        self = .from(group.rawValue, group.offset!)
    }
    
    case
    from(String, Int)
    
    var name: String {
        switch self {
        case .from(let name, _): return name
        }
    }
    
    var id: Int {
        switch self {
        case .from(_, let id): return id
        }
    }
}

extension ApiGroup: CustomStringConvertible {
    var description: String {
        return name
    }
}

