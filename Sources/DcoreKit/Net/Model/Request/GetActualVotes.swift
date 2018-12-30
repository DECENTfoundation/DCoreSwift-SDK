import Foundation

class GetActualVotes: BaseRequest<[MinerVotes]> {
    
    required init() {
        super.init(.database, api: "get_actual_votes", returnClass: [MinerVotes].self)
    }
}
