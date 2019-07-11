import Foundation
import RxSwift

public protocol ContentApi: BaseApi {
    /**
     Get content by id.
     
     - Parameter id: Content id, eg. 2.13.*,
     as `ChainObject` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if account does not exist.
     
     - Returns: `Content`.
     */
    func get(byId id: ChainObjectConvertible) -> Single<Content>
    
    /**
     Get content by url.
     
     - Parameter url: Content uri,
     as `URL` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if content does not exist.
     
     - Returns: `Content`.
     */
    func get(byUrl url: URLConvertible) -> Single<Content>
    
    /**
     Get content by reference (id or URL in String format).
     
     - Parameter ref: Reference (id or URL in String format).
     
     - Throws: `DCoreException.Network.notFound`
     if content does not exist.
     
     - Returns: `Content`.
     */
    func get(byReference ref: Content.Reference) -> Single<Content>
    
    /**
     Check if content exist by url.
     
     - Parameter url: Content uri,
     as `URL` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if account does not exist.
     
     - Returns: `true` if content exist.
     */
    func exist(byUrl url: URLConvertible) -> Single<Bool>
    
    /**
     Find contents by expression (author, title and description).
     
     - Parameter expression: Lookup expression.
     - Parameter order: Ordering field, default `SearchOrder.Content.createdDesc`.
     - Parameter author: Content owner account name, default `empty`.
     - Parameter regionCode: Two letter region code, default `Regions.all`
     - Parameter type: Application and content type to be filtered,
     default `ContentCategory.id(.decentCore, .none)`.
     - Parameter startId: Id of content object to start searching from,
     as `ChainObject` or `String` format.
     - Parameter limit: Maximum number of contents to fetch, max/default `100`.
   
     - Returns: Array `[Content]` of lookup contents.
     */
    // swiftlint:disable:next function_parameter_count
    func findAll(by expression: String,
                 order: SearchOrder.Content,
                 author: Account.Reference,
                 regionCode: String,
                 type: String,
                 startId id: ChainObjectConvertible,
                 limit: Int) -> Single<[Content]>
    
    /**
     Get a list of accounts holding publishing manager status.
     
     - Parameter bound: Name of the first account to return.
     If the named account does not exist,
     the list will start at the account that comes after lowerbound.
     - Parameter limit: Maximum number of accounts to return,
     max/default `100`.
     
     - Returns: Array `[ChainObject]` of publishing managers.
     */
    func findAllPublishersRelative(byLower bound: String, limit: Int) -> Single<[ChainObject]>
    
    /**
     Generate keys for new content submission.
     
     - Parameter ids: List of seeder account ids.
     
     - Returns: Generated key and key parts.
     */
    func generateKeys(forSeeders ids: [ChainObjectConvertible]) -> Single<ContentKeys>

    /**
     Restores encryption key from key parts stored in buying object.
     
     - Parameter privateKey: Private El Gamal key.
     - Parameter id: Id of purchase object
     
     - Returns: AES encryption key.
     */
    func restoreKey(byElGamal privateKey: PubKey, purchaseId id: ChainObjectConvertible) -> Single<String>
    
    /**
     Create content.
     
     - Parameter content: SubmitContent object.
     - Parameter author: Credentials of account which will pay operation fee,
     will owner of content.
     - Parameter publishingFee: `AssetAmount` fee,
     if left `AssetAmount.unset` the fee will be computed in DCT asset,
     default `AssetAmount.unset`.
     - Parameter fee: `AssetAmount` fee for the operation,
     if left `AssetAmount.unset` the fee will be computed in DCT asset,
     default `AssetAmount.unset`.
     
     - Throws: `DCoreException.Network.alreadyFound`
     if content with given uri already exist.
     
     - Returns: `TransactionConfirmation` that content was created. 
     */
    func create<Input>(on content: SubmitContent<Input>,
                       author: Credentials,
                       publishingFee: AssetAmount,
                       fee: AssetAmount) -> Single<TransactionConfirmation> where Input: SynopsisConvertible

    /**
     Update content.
     
     - Parameter reference: Content reference (id or uri) of object to update.
     - Parameter credentials: Credentials of owner account, which will pay operation fee.
     - Parameter newSynopsis: Updated synopsis.
     - Parameter newPrice: Updated price.
     - Parameter newCoAuthors: Updated coauthors.
     - Parameter fee: `AssetAmount` fee for the operation,
     if left `AssetAmount.unset` the fee will be computed in DCT asset,
     default `AssetAmount.unset`.
     
     - Throws: `DCoreException.Network.notFound`
     if content with given reference does not exist.
     
     - Returns: `TransactionConfirmation` that content was updated.
     */
    func update<Input>(on reference: Content.Reference,
                       credentials: Credentials,
                       newSynopsis: Input?,
                       newPrice: AssetAmount?,
                       newCoAuthors: [Pair<ChainObject, Int>]?,
                       fee: AssetAmount) -> Single<TransactionConfirmation> where Input: SynopsisConvertible
    /**
     Delete content by reference (id or uri).
     
     - Parameter ref: Content reference (id or uri).
     - Parameter author: Credentials of account which will pay operation fee,
     will owner of content.
     - Parameter fee: `AssetAmount` fee for the operation,
     if left `AssetAmount.unset` the fee will be computed in DCT asset,
     default `AssetAmount.unset`.
     
     - Throws: `DCoreException.Network.notFound`
     if content with given reference does not exist.
     
     - Returns: `TransactionConfirmation` that content was deleted.
     */
    func delete(byReference ref: Content.Reference, author: Credentials, fee: AssetAmount) -> Single<TransactionConfirmation>
    
    /**
     Delete content by id.
     
     - Parameter id: Content id, as `ChainObject` or `String` format.
     - Parameter author: Credentials of account which will pay operation fee,
     will owner of content.
     - Parameter fee: `AssetAmount` fee for the operation,
     if left `AssetAmount.unset` the fee will be computed in DCT asset,
     default `AssetAmount.unset`.
     
     - Throws: `DCoreException.Network.notFound`
     if content with given id does not exist.
     
     - Returns: `TransactionConfirmation` that content was deleted.
     */
    func delete(byId id: ChainObjectConvertible, author: Credentials, fee: AssetAmount) -> Single<TransactionConfirmation>
    
    /**
     Delete content by url (URL or String).
     
     - Parameter url: URL or String.
     - Parameter author: Credentials of account which will pay operation fee,
     will owner of content.
     - Parameter fee: `AssetAmount` fee for the operation,
     if left `AssetAmount.unset` the fee will be computed in DCT asset,
     default `AssetAmount.unset`.
     
     - Throws: `DCoreException.Network.notFound`
     if content with given uri does not exist.
     
     - Returns: `TransactionConfirmation` that content was deleted.
     */
    func delete(byUrl url: URLConvertible, author: Credentials, fee: AssetAmount) -> Single<TransactionConfirmation>

    /**
     Create a purchase content operation.
     
     - Parameter id: Content id, as `ChainObject` or `String` format.
     - Parameter consumer: Account credentials.
     
     - Throws: `DCoreException.Network.notFound`
     if content with given id does not exist.
     
     - Returns: `PurchaseContentOperation`.
     */
    func createPurchase(byId id: ChainObjectConvertible, consumer: Credentials) -> Single<PurchaseContentOperation>
    
    /**
     Create a purchase content operation.
     
     - Parameter url: URL or String.
     - Parameter consumer: Account credentials.
     
     - Throws: `DCoreException.Network.notFound`
     if content with given id does not exist.
     
     - Returns: `PurchaseContentOperation`.
     */
    func createPurchase(byUrl url: URLConvertible, consumer: Credentials) -> Single<PurchaseContentOperation>
    
    /**
     Make a content purchase.
     
     - Parameter id: Content id, as `ChainObject` or `String` format.
     - Parameter consumer: Account credentials.
     
     - Throws: `DCoreException.Network.notFound`
     if content with given id does not exist.
     
     - Returns: `TransactionConfirmation` of successfull purchase.
     */
    func purchase(byId id: ChainObjectConvertible, consumer: Credentials) -> Single<TransactionConfirmation>
    
    /**
     Make a content purchase.
     
     - Parameter url: URL or String.
     - Parameter consumer: Account credentials.
     
     - Throws: `DCoreException.Network.notFound`
     if content with given url does not exist.
     
     - Returns: `TransactionConfirmation` of successfull purchase.
     */
    func purchase(byUrl url: URLConvertible, consumer: Credentials) -> Single<TransactionConfirmation>
    
    /**
     Create recurrent transfers operation to transfer an amount of one asset to content.
     Amount is transferred to author and co-authors of the content, if they are specified.
     Fees are paid by the `from` account.
     
     - Parameter ref: Receiver content reference.
     - Parameter consumer: Sender account credentials.
     - Parameter amount: `AssetAmount` to send with asset type.
     - Parameter message: Message (Optional).
     - Parameter encrypted: If message present,
     encrypted is visible only for sender and receiver,
     unencrypted is visible publicly, default `true`.
     - Parameter fee: `AssetAmount` fee for the operation,
     if left `AssetAmount.unset` the fee will be computed in DCT asset,
     default `AssetAmount.unset`.
     
     - Throws: `DCoreException.Network.notFound`
     if content with given reference does not exist.
     
     - Returns: `TransferOperation`.
     */
    func createTransfer(toReference ref: Content.Reference,
                        from consumer: Credentials,
                        amount: AssetAmount,
                        message: String?,
                        fee: AssetAmount) -> Single<TransferOperation>
    
    /**
     Make recurrent transfer an amount of one asset to content.
     Amount is transferred to author and co-authors of the content, if they are specified.
     Fees are paid by the `from` account.
     
     - Parameter ref: Receiver content reference.
     - Parameter consumer: Sender account credentials.
     - Parameter amount: `AssetAmount` to send with asset type.
     - Parameter message: Message (Optional).
     - Parameter encrypted: If message present,
     encrypted is visible only for sender and receiver,
     unencrypted is visible publicly, default `true`.
     - Parameter fee: `AssetAmount` fee for the operation,
     if left `AssetAmount.unset` the fee will be computed in DCT asset,
     default `AssetAmount.unset`.
     
     - Throws: `DCoreException.Network.notFound`
     if content with given reference does not exist.
     
     - Returns: A transaction confirmation.
     */
    func transfer(toReference ref: Content.Reference,
                  from consumer: Credentials,
                  amount: AssetAmount,
                  message: String?,
                  fee: AssetAmount) -> Single<TransactionConfirmation>
}

extension ContentApi {
    public func get(byId id: ChainObjectConvertible) -> Single<Content> {
        return Single.deferred {
            return GetContentById(try id.asChainObject()).base.toResponse(self.api.core).map {
                try $0.first.orThrow(DCoreException.network(.notFound))
            }
        }
    }
    
    public func get(byUrl url: URLConvertible) -> Single<Content> {
        return Single.deferred {
            return GetContentByUri(try url.asURI { Content.hasValid(uri: $0) }).base.toResponse(self.api.core)
        }
        
    }
    
    public func get(byReference ref: Content.Reference) -> Single<Content> {
        return Single.deferred {
            if Content.hasValid(uri: ref) {
                return self.get(byUrl: ref)
            }
            return self.get(byId: try ref.asChainObject())
        }
    }
    
    public func exist(byUrl url: URLConvertible) -> Single<Bool> {
        return get(byUrl: url).map { _ in true }.catchErrorJustReturn(false)
    }
    
    public func findAll(by expression: String,
                        order: SearchOrder.Content = .createdDesc,
                        author: Account.Reference = "",
                        regionCode: String = Regions.all.code,
                        type: String = ContentCategory.id(.decentCore, .none).description,
                        startId id: ChainObjectConvertible = ObjectType.nullObject.genericId,
                        limit: Int = DCore.Limits.content) -> Single<[Content]> {
        return Single.deferred {
            return SearchContent(expression,
                                 order: order,
                                 user: author,
                                 regionCode: regionCode,
                                 type: type,
                                 startId: try id.asChainObject(),
                                 limit: try limit.limited(by: DCore.Limits.content))
                .base
                .toResponse(self.api.core)
        }
    }
        
    public func findAllPublishersRelative(byLower bound: String, limit: Int = DCore.Limits.publisher) -> Single<[ChainObject]> {
        return Single.deferred {
            return ListPublishingManagers(bound, limit: try limit.limited(by: DCore.Limits.publisher))
                .base
                .toResponse(self.api.core)
        }
    }
    
    public func generateKeys(forSeeders ids: [ChainObjectConvertible]) -> Single<ContentKeys> {
        return Single.deferred {
            return GenerateContentKeys(try ids.map { try $0.asChainObject() }).base.toResponse(self.api.core)
        }
    }
    
    public func restoreKey(byElGamal privateKey: PubKey, purchaseId id: ChainObjectConvertible) -> Single<String> {
        return Single.deferred {
            return RestoreEncryptionKey(privateKey, purchaseId: try id.asChainObject()).base.toResponse(self.api.core)
        }
    }
    
    public func create<Input>(on content: SubmitContent<Input>,
                              author: Credentials,
                              publishingFee: AssetAmount = .unset,
                              fee: AssetAmount = .unset) -> Single<TransactionConfirmation> where Input: SynopsisConvertible {
        return exist(byUrl: content.uri).flatMap { result in
            guard !result else { return Single.error(DCoreException.network(.alreadyFound)) }
            return self.api.broadcast.broadcastWithCallback(SubmitContentOperation(
                content, author: author, publishingFee: publishingFee, fee: fee
            ), keypair: author.keyPair)
        }
    }

    public func update<Input>(on reference: Content.Reference,
                              credentials: Credentials,
                              newSynopsis: Input?,
                              newPrice: AssetAmount?,
                              newCoAuthors: [Pair<ChainObject, Int>]?,
                              fee: AssetAmount) -> Single<TransactionConfirmation> where Input: SynopsisConvertible {
        return get(byReference: reference).flatMap { originalContent in
            self.api.broadcast.broadcastWithCallback(SubmitContentOperation(
                try originalContent.modifiedSubmitContent(
                    by: newSynopsis,
                    newPrice: newPrice,
                    newCoAuthors: newCoAuthors
                ),
                author: credentials,
                publishingFee: .unset,
                fee: fee
            ), keypair: credentials.keyPair)
        }
    }
    
    public func delete(byReference ref: Content.Reference, author: Credentials, fee: AssetAmount = .unset) -> Single<TransactionConfirmation> {
        return Single.deferred {
            if let id = ref.dcore.chainObject {
                return self.delete(byId: id, author: author, fee: fee)
            }
            if Content.hasValid(uri: ref) {
                return self.delete(byUrl: ref, author: author, fee: fee)
            }
            return Single.error(DCoreException.unexpected("\(ref) is not a valid content reference"))
        }
    }
    
    public func delete(byId id: ChainObjectConvertible, author: Credentials, fee: AssetAmount = .unset) -> Single<TransactionConfirmation> {
        return get(byId: id).flatMap {
            self.delete(byUrl: $0.uri, author: author, fee: fee)
        }
    }
    
    public func delete(byUrl url: URLConvertible, author: Credentials, fee: AssetAmount = .unset) -> Single<TransactionConfirmation> {
        return Single.deferred {
            return self.api.broadcast.broadcastWithCallback(CancelContentOperation(
                author: author.accountId, uri: try url.asURI { Content.hasValid(uri: $0) }, fee: fee
            ), keypair: author.keyPair)
        }
    }
    
    public func createPurchase(byId id: ChainObjectConvertible,
                               consumer: Credentials) -> Single<PurchaseContentOperation> {
        return get(byId: id).map { PurchaseContentOperation(consumer, content: $0) }
    }
    
    public func createPurchase(byUrl url: URLConvertible,
                               consumer: Credentials) -> Single<PurchaseContentOperation> {
        return get(byUrl: url).map { PurchaseContentOperation(consumer, content: $0) }
    }
    
    public func purchase(byId id: ChainObjectConvertible,
                         consumer: Credentials) -> Single<TransactionConfirmation> {
        return createPurchase(byId: id, consumer: consumer).flatMap {
            self.api.broadcast.broadcastWithCallback($0, keypair: consumer.keyPair)
        }
    }
    
    public func purchase(byUrl url: URLConvertible,
                         consumer: Credentials) -> Single<TransactionConfirmation> {
        return createPurchase(byUrl: url, consumer: consumer).flatMap {
            self.api.broadcast.broadcastWithCallback($0, keypair: consumer.keyPair)
        }
    }
    
    public func createTransfer(toReference ref: Content.Reference,
                               from consumer: Credentials,
                               amount: AssetAmount,
                               message: String? = nil,
                               fee: AssetAmount = .unset) -> Single<TransferOperation> {
        return get(byReference: ref).map {
            var memo: Memo?
            if let message = message {
                memo = try? Memo(message, keyPair: nil, recipient: nil)
            }
            
            return TransferOperation(from: consumer.accountId,
                                     to: $0.id,
                                     amount: amount,
                                     memo: memo,
                                     fee: fee)
        }
    }
    
    public func transfer(toReference ref: Content.Reference,
                         from consumer: Credentials,
                         amount: AssetAmount,
                         message: String? = nil,
                         fee: AssetAmount = .unset) -> Single<TransactionConfirmation> {
        return createTransfer(toReference: ref, from: consumer, amount: amount, message: message, fee: fee)
            .flatMap { self.api.broadcast.broadcastWithCallback($0, keypair: consumer.keyPair) }
    }
}

extension ApiProvider: ContentApi {}
