import Foundation
import RxSwift
import RxCocoa

class RpcService {

    private let url: URL
    private let session: URLSession
    
    init(url: URL, session: URLSession? = nil) {
        self.url = url
        self.session = session ?? URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func request<T>(using req: BaseRequest<T>) -> Single<T> {
        return self.session.rx.data(request: RpcRequestBuilder(base: req).toURLRequest(url: self.url)).asSingle().flatMap({ data in
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
                if let error = json?[ResponseKey.error.rawValue] {
                    return Single.error(ChainError.runtime(error))
                } else if let _ = json?[ResponseKey.result.rawValue], req.returnClass == Void.self {
                    return Single.error(ChainError.notFound(req.description)) //Completable.empty()
                } else if let result = json?[ResponseKey.result.rawValue] as? [Any], result.isEmpty {
                    return Single.error(ChainError.notFound(req.description))
                } else {
                    return Single.error(ChainError.illegal("invalid HTTP API response"))
                }
                
            } catch let error {
                return Single.error(ChainError.underlying(error))
            }
        })
    }
}

/*
 private interface RpcEndpoint {
 @POST("rpc")
 fun request(@Body request: RequestBody): Single<ResponseBody>
 }
 
 private val service = Retrofit.Builder()
 .baseUrl(url)
 .addCallAdapterFactory(RxJava2CallAdapterFactory.createAsync())
 .addConverterFactory(GsonConverterFactory.create(DCoreSdk.gsonBuilder.create()))
 .client(client)
 .build()
 .create(RpcEndpoint::class.java)
 
 private fun BaseRequest<*>.toRequestBody(): RequestBody = RequestBody.create(MEDIA_TYPE, gson.toJson(this))
 
 @Suppress("UNCHECKED_CAST")
 fun <T> request(request: BaseRequest<T>): Single<T> =
 service.request(request.toRequestBody())
 .map { JsonParser().parse(it.charStream()).asJsonObject }
 .flatMap {
 when {
 it.has("error") -> Single.error(DCoreException(gson.fromJson(it["error"], Error::class.java)))
 it.has("result") && request.returnClass == Unit::class.java -> Single.just(Unit) as Single<T>
 it.has("result") && ((it["result"].isJsonArray && it["result"].asJsonArray.contains(JsonNull.INSTANCE)) || it["result"] == JsonNull.INSTANCE)
 -> Single.error(ObjectNotFoundException(request.description()))
 it.has("result") -> Single.just<T>(gson.fromJson(it["result"], request.returnClass))
 else -> Single.error(IllegalStateException("invalid HTTP API response"))
 }
 }
 
 companion object {
 private val MEDIA_TYPE = MediaType.parse("application/json; charset=UTF-8")
 }

 
 */
