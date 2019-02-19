import Foundation
import RxSwift

public protocol BlockApi: BaseApi {
    func getBlockHeader(byNum num: UInt64) -> Single<BlockHeader>
    func headBlockTime() -> Single<Date>
    func getBlock(byNum num: UInt64) -> Single<SignedBlock>
}

extension BlockApi {
    public func getBlockHeader(byNum num: UInt64) -> Single<BlockHeader> {
        return GetBlockHeader(num).base.toResponse(api.core).map { $0.apply(num: num) }
    }
    
    public func headBlockTime() -> Single<Date> {
        return HeadBlockTime().base.toResponse(api.core)
    }
    
    public func getBlock(byNum num: UInt64) -> Single<SignedBlock> {
        return GetBlock(num).base.toResponse(api.core)
    }
}

extension ApiProvider: BlockApi {}
