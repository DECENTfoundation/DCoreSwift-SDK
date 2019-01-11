import Foundation
import RxSwift

public final class SeedersApi: BaseApi {
    
    public func getSeeder(byAccountId id: ChainObject) -> Single<Seeder> {
        return GetSeeder(id).base.asCoreRequest(api.core)
    }
    
    public func listSeedersByPrice(count: Int = 100) -> Single<[Seeder]> {
        return ListSeedersByPrice(count).base.asCoreRequest(api.core)
    }
    
    public func listSeedersByUpload(count: Int = 100) -> Single<[Seeder]> {
        return ListSeedersByUpload(count).base.asCoreRequest(api.core)
    }
    
    public func listSeedersByRegion(region: String = Regions.ALL.code) -> Single<[Seeder]> {
        return ListSeedersByRegion(region).base.asCoreRequest(api.core)
    }
    
    public func listSeedersByRating(count: Int = 100) -> Single<[Seeder]> {
        return ListSeedersByRating(count).base.asCoreRequest(api.core)
    }
}
