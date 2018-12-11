import Foundation

class GetTimeToMaintenance: BaseRequest<MinerRewardInput> {
    
    required init(time: Date) {
        super.init(api: .DATABASE, method: "get_time_to_maint_by_block_time", returnClass: MinerRewardInput.self, params: [time])
    }
}


