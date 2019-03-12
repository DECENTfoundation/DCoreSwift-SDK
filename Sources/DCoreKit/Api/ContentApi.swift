import Foundation
import RxSwift

public protocol ContentApi: BaseApi {
    func getContent(byId id: ChainObject) -> Single<Content>
    func getContent(byUri uri: String) -> Single<Content>
    func exist(byUri uri: String) -> Single<Bool>
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
    func create<Input>(_ content: SubmitContent<Input>,
                       credentials: Credentials,
                       publishingFee: AssetAmount,
                       fee: AssetAmount) -> Single<TransactionConfirmation> where Input: SynopsisConvertible
    func delete(byReference ref: Content.Reference, credentials: Credentials, fee: AssetAmount) -> Single<TransactionConfirmation>
    func delete(byId id: ChainObject, credentials: Credentials, fee: AssetAmount) -> Single<TransactionConfirmation>
    func delete(byUri uri: String, credentials: Credentials, fee: AssetAmount) -> Single<TransactionConfirmation>
}

extension ContentApi {
    public func getContent(byId id: ChainObject) -> Single<Content> {
        return GetContentById(id).base.toResponse(api.core).map({ try $0.first.orThrow(DCoreException.network(.notFound)) })
    }
    
    public func getContent(byUri uri: String) -> Single<Content> {
        return GetContentByUri(uri).base.toResponse(api.core)
    }
    
    public func exist(byUri uri: String) -> Single<Bool> {
        return getContent(byUri: uri).map({ _ in true }).catchErrorJustReturn(false)
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
    
    public func create<Input>(_ content: SubmitContent<Input>,
                              credentials: Credentials,
                              publishingFee: AssetAmount = .unset,
                              fee: AssetAmount = .unset) -> Single<TransactionConfirmation> where Input: SynopsisConvertible {
        return exist(byUri: content.uri).flatMap { result in
            guard !result else { return Single.error(DCoreException.network(.alreadyFound)) }
            return self.api.broadcast.broadcast(withCallback: credentials.keyPair, operation: SubmitContentOperation(
                content, credentials: credentials, publishingFee: publishingFee, fee: fee
                )
            )
        }
    }
    
    public func delete(byReference ref: Content.Reference, credentials: Credentials, fee: AssetAmount = .unset) -> Single<TransactionConfirmation> {
        return Single.deferred {
            if let id = ref.dcore.chainObject {
                return self.delete(byId: id, credentials: credentials, fee: fee)
            }
            
            if Content.hasValid(uri: ref) {
                return self.delete(byUri: ref, credentials: credentials, fee: fee)
            }
            
            return Single.error(DCoreException.unexpected("\(ref) is not a valid content reference"))
        }
    }
    
    public func delete(byId id: ChainObject, credentials: Credentials, fee: AssetAmount = .unset) -> Single<TransactionConfirmation> {
        return getContent(byId: id).flatMap {
            self.delete(byUri: $0.uri, credentials: credentials, fee: fee)
        }
    }
    
    public func delete(byUri uri: String, credentials: Credentials, fee: AssetAmount = .unset) -> Single<TransactionConfirmation> {
        return self.api.broadcast.broadcast(withCallback: credentials.keyPair, operation: CancelContentOperation(
            author: credentials.accountId, uri: uri, fee: fee
            )
        )
    }
}

extension ApiProvider: ContentApi {}
