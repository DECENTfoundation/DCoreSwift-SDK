import Foundation
import RxSwift

public protocol BlockApi: BaseApi {
    func getBlockHeader(byNum num: UInt64) -> Single<BlockHeader>
    func headBlockTime() -> Single<Date>
    
    func getBlock<Input>(byNum num: UInt64) -> Single<SignedBlock<Input>> where Input: Operation
    func getAnyBlock(byNum num: UInt64) -> Single<AnySignedBlock>
}

extension BlockApi {
    public func getBlockHeader(byNum num: UInt64) -> Single<BlockHeader> {
        return GetBlockHeader(num).base.toResponse(api.core)
    }
    
    public func headBlockTime() -> Single<Date> {
        return HeadBlockTime().base.toResponse(api.core)
    }
    
    public func getBlock<Input>(byNum num: UInt64) -> Single<SignedBlock<Input>> where Input: Operation {
        return GetBlock(num).base.toResponse(api.core)
    }
    
    public func getAnyBlock(byNum num: UInt64) -> Single<AnySignedBlock> {
        return getBlock(byNum: num)
    }
}

extension ApiProvider: BlockApi {}
