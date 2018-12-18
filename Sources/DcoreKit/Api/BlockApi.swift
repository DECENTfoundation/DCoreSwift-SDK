import Foundation
import RxSwift

public final class BlockApi: BaseApi {

    public func getBlockHeader(byBlockNum num: UInt64) -> Single<BlockHeader> {
        return GetBlockHeader(blockNum: num).toRequest(core: self.api.core)
    }

    public func headBlockTime() -> Single<Date>{
        return HeadBlockTime().toRequest(core: self.api.core)
    }

    public func getBlock(byBlockNum num: UInt64) -> Single<SignedBlock> {
        return GetBlock(blockNum: num).toRequest(core: self.api.core)
    }
}
