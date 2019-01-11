import Foundation

struct GetActualVotes: BaseRequestConvertible {
    
    typealias Output = [MinerVotes]
    private(set) var base: BaseRequest<[MinerVotes]>
    
    init() {
        self.base = GetActualVotes.toBase(.database, api: "get_actual_votes", returnClass: [MinerVotes].self)
    }
}
