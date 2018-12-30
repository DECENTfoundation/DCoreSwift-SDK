import Foundation

class GetTimeToMaintenance: BaseRequest<MinerRewardInput> {
    
    required init(time: Date) {
        super.init(.database, api: "get_time_to_maint_by_block_time", returnClass: MinerRewardInput.self, params: [time])
    }
}


