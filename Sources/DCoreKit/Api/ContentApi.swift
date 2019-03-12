import Foundation
import RxSwift

public protocol ContentApi: BaseApi {
    func getContent(byId id: ChainObject) -> Single<Content>
    func getContent(byUri uri: String) -> Single<Content>
    // swiftlint:disable:next function_parameter_count
    func search(contentByTerm term: String,
                order: SearchOrder.Content,
                user: String,
                regionCode: String,
                type: String,
                startId: ChainObject,
                limit: Int) -> Single<[Content]>
    func listPublishingManagers(lowerBound: String, limit: Int) -> Single<[ChainObject]>
    func generateContentKeys(forSeeders ids: [ChainObject]) -> Single<ContentKeys>
    func restoreEncryptionKey(elGamalPrivate: PubKey, purchaseId: ChainObject) -> Single<String>
    func submit<Input>(_ creds: Credentials,
                       content: SubmitContent<Input>,
                       publishingFee: AssetAmount,
                       fee: AssetAmount) -> Single<TransactionConfirmation> where Input: SynopsisConvertible
}

extension ContentApi {
    public func getContent(byId id: ChainObject) -> Single<Content> {
        return GetContentById(id).base.toResponse(api.core).map({ try $0.first.orThrow(DCoreException.network(.notFound)) })
    }
    
    public func getContent(byUri uri: String) -> Single<Content> {
        return GetContentByUri(uri).base.toResponse(api.core)
    }
    
    public func search(contentByTerm term: String,
                       order: SearchOrder.Content = .createdDesc,
                       user: String = "",
                       regionCode: String = Regions.all.code,
                       type: String = ContentCategory.id(.decentCore, .none).description,
                       startId: ChainObject = ObjectType.nullObject.genericId,
                       limit: Int = 100) -> Single<[Content]> {
        
        return SearchContent(term,
                             order: order,
                             user: user,
                             regionCode: regionCode,
                             type: type,
                             startId: startId,
                             limit: limit).base.toResponse(api.core)
    }
    
    public func listPublishingManagers(lowerBound: String, limit: Int = 100) -> Single<[ChainObject]> {
        return ListPublishingManagers(lowerBound, limit: limit).base.toResponse(api.core)
    }
    
    public func generateContentKeys(forSeeders ids: [ChainObject]) -> Single<ContentKeys> {
        return GenerateContentKeys(ids).base.toResponse(api.core)
    }
    
    public func restoreEncryptionKey(elGamalPrivate: PubKey, purchaseId: ChainObject) -> Single<String> {
        return RestoreEncryptionKey(elGamalPrivate, purchaseId: purchaseId).base.toResponse(api.core)
    }
    
    public func submit<Input>(_ creds: Credentials,
                              content: SubmitContent<Input>,
                              publishingFee: AssetAmount = .unset,
                              fee: AssetAmount = .unset) -> Single<TransactionConfirmation> where Input: SynopsisConvertible {
        return self.api.broadcast.broadcast(withCallback: creds.keyPair, operation: SubmitContentOperation(
            credentials: creds, content: content, publishingFee: publishingFee, fee: fee
            )
        )
    }
}

extension ApiProvider: ContentApi {}
