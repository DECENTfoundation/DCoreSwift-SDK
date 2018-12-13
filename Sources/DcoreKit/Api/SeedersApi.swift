import Foundation
import RxSwift

public class SeedersApi: BaseApi {
    
    public func getSeeder(byAccountId id: ChainObject) -> Single<Seeder> {
        return GetSeeder(accountId: id).toRequest(core: self.api.core)
    }
    
    public func listSeedersByPrice(count: Int = 100) -> Single<[Seeder]> {
        return ListSeedersByPrice(count: count).toRequest(core: self.api.core)
    }
    
    public func listSeedersByUpload(count: Int = 100) -> Single<[Seeder]> {
        return ListSeedersByUpload(count: count).toRequest(core: self.api.core)
    }
    
    public func listSeedersByRegion(region: String = Regions.ALL.code) -> Single<[Seeder]> {
        return ListSeedersByRegion(region: region).toRequest(core: self.api.core)
    }
    
    public func listSeedersByRating(count: Int = 100) -> Single<[Seeder]> {
        return ListSeedersByRating(count: count).toRequest(core: self.api.core)
    }
}
