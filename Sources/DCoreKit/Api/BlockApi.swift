import Foundation
import RxSwift

public protocol BlockApi: BaseApi {
    /**
     Get a full, signed block.
     
     - Parameter num: Height of the block whose header should be returned.
     
     - Throws: `DCoreException.Network.notFound`
     if no matching block was found.
     
     - Returns: `SignedBlock`.
     */
    func get(byNum num: UInt64) -> Single<SignedBlock>
    
    /**
     Get block header
     
     - Parameter num: Height of the block whose header should be returned.

     - Throws: `DCoreException.Network.notFound`
     if no matching block was found.
     
     - Returns: `BlockHeader` of the referenced block.
     */
    func getHeader(byNum num: UInt64) -> Single<BlockHeader>
    
    /**
     Get last local block time.
     
     - Returns: `Date` as block time.
     */
    func getHeadTime() -> Single<Date>
}

extension BlockApi {
    public func get(byNum num: UInt64) -> Single<SignedBlock> {
        return GetBlock(num).base.toResponse(api.core)
    }
    
    public func getHeader(byNum num: UInt64) -> Single<BlockHeader> {
        return GetBlockHeader(num).base.toResponse(api.core).map { $0.apply(num: num) }
    }
    
    public func getHeadTime() -> Single<Date> {
        return HeadBlockTime().base.toResponse(api.core)
    }
}

extension ApiProvider: BlockApi {}
