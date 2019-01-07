import Foundation
import RxSwift

public final class BlockApi: BaseApi {

    public func getBlockHeader(byBlockNum num: UInt64) -> Single<BlockHeader> {
        return GetBlockHeader(blockNum: num).toCoreRequest(api.core)
    }

    public func headBlockTime() -> Single<Date>{
        return HeadBlockTime().toCoreRequest(api.core)
    }

    public func getBlock(byBlockNum num: UInt64) -> Single<SignedBlock> {
        return GetBlock(blockNum: num).toCoreRequest(api.core)
    }
}
