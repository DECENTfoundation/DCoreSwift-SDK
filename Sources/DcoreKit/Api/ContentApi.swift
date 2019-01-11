import Foundation
import RxSwift

public final class ContentApi: BaseApi {
    
    public func getContent(byId id: ChainObject) -> Single<Content> {
        return GetContentById(id).base.asChainRequest(api.core).map({ $0.first! })
    }

    public func getContent(byUri uri: String) -> Single<Content> {
        return GetContentByUri(uri).base.asChainRequest(api.core)
    }
    
    public func search(contentByTerm term: String,
                       order: SearchOrder.Content = .createdDesc,
                       user: String = "",
                       regionCode: String = Regions.ALL.code,
                       type: String = ContentCategory.id(.decentCore, .none).description,
                       startId: ChainObject = ObjectType.nullObject.genericId,
                       limit: Int = 100) -> Single<[Content]> {
        
        return SearchContent(term, order: order, user: user, regionCode: regionCode, type: type, startId: startId, limit: limit).base.asChainRequest(api.core)
    }
    
    public func listPublishingManagers(lowerBound: String, limit: Int = 100) -> Single<[ChainObject]> {
        return ListPublishingManagers(lowerBound, limit: limit).base.asChainRequest(api.core)
    }
    
    public func generateContentKeys(forSeeders ids: [ChainObject]) -> Single<ContentKeys> {
        return GenerateContentKeys(ids).base.asChainRequest(api.core)
    }
    
    public func restoreEncryptionKey(elGamalPrivate: PubKey, purchaseId: ChainObject) -> Single<String> {
        return RestoreEncryptionKey(elGamalPrivate, purchaseId: purchaseId).base.asChainRequest(api.core)
    }
}
