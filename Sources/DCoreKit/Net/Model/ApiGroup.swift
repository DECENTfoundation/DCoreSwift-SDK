import Foundation

// 0 - database
// 1 - login
// 2 - network/broadcast
// 3 - history
// 4 - crypto
// 5 - messaging
// 6 - network/node
// 7 - monitoring

enum ApiGroup {
    
    static let database: ApiGroup =     ApiGroup(group: .database)
    static let login: ApiGroup =        ApiGroup(group: .login)
    static let broadcast: ApiGroup =    ApiGroup(group: .broadcast)
    static let history: ApiGroup =      ApiGroup(group: .history)
    static let crypto: ApiGroup =       ApiGroup(group: .crypto)
    static let messaging: ApiGroup =    ApiGroup(group: .messaging)
    static let node: ApiGroup =         ApiGroup(group: .node)
    static let monitoring: ApiGroup =   ApiGroup(group: .monitoring)

    private enum Category: String, CaseIterable {
        case
        database = "database_api",
        login = "",
        broadcast = "network_broadcast_api",
        history = "history_api",
        crypto = "crypto_api",
        messaging = "messaging_api",
        node = "network_node_api",
        monitoring = "monitoring_api"
    }
    
    private init(group: Category) {
        self = .from(group.rawValue)
    }
    
    case
    from(String)
    
    var name: String {
        switch self {
        case .from(let name): return name
        }
    }
}

extension ApiGroup: CustomStringConvertible {
    var description: String {
        return name
    }
}
