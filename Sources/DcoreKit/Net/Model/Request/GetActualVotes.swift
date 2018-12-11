import Foundation

class GetActualVotes: BaseRequest<[MinerVotes]> {
    
    required init() {
        super.init(api: .DATABASE, method: "get_actual_votes", returnClass: [MinerVotes].self)
    }
}
