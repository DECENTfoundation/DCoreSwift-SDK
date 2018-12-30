import Foundation
import RxSwift

public final class ContentApi: BaseApi {
    
    public func getContent(byId id: ChainObject) -> Single<Content> {
        return GetContentById(contentId: id).toRequest(core: api.core).map({ $0.first! })
    }

    public func getContent(byUri uri: String) -> Single<Content> {
        return GetContentByUri(uri: uri).toRequest(core: api.core)
    }
    
    public func search(contentByTerm term: String,
                       order: SearchContentOrder = .CREATED_DESC,
                       user: String = "",
                       regionCode: String = Regions.ALL.code,
                       type: String = ContentCategory.id(.DECENT_CORE, .NONE).description,
                       startId: ChainObject = ObjectType.nullObject.genericId,
                       limit: Int = 100) -> Single<[Content]> {
        
        return SearchContent(term: term, order: order, user: user, regionCode: regionCode, type: type, startId: startId, limit: limit).toRequest(core: api.core)
    }
    
    public func listPublishingManagers(lowerBound: String, limit: Int = 100) -> Single<[ChainObject]> {
        return ListPublishingManagers(lowerBound: lowerBound, limit: limit).toRequest(core: api.core)
    }
    
    public func generateContentKeys(forSeeders ids: [ChainObject]) -> Single<ContentKeys> {
        return GenerateContentKeys(seeders: ids).toRequest(core: api.core)
    }
    
    public func restoreEncryptionKey(elGamalPrivate: PubKey, purchaseId: ChainObject) -> Single<String> {
        return RestoreEncryptionKey(elGamalPrivate: elGamalPrivate, purchaseId: purchaseId).toRequest(core: api.core)
    }
}
