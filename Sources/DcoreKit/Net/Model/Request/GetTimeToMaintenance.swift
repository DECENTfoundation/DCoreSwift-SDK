import Foundation

struct GetTimeToMaintenance: BaseRequestConvertible {
    
    typealias Output = MinerRewardInput
    private(set) var base: BaseRequest<MinerRewardInput>
    
    init(_ time: Date) {
        self.base = GetTimeToMaintenance.toBase(.database, api: "get_time_to_maint_by_block_time", returnClass: MinerRewardInput.self, params: [time])
    }
}
