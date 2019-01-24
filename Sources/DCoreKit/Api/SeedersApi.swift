import Foundation
import RxSwift

public protocol SeedersApi: BaseApi {
    func getSeeder(byAccountId id: ChainObject) -> Single<Seeder>
    func listSeedersByPrice(_ count: Int) -> Single<[Seeder]>
    func listSeedersByUpload(_ count: Int) -> Single<[Seeder]>
    func listSeedersByRegion(_ region: String) -> Single<[Seeder]>
    func listSeedersByRating(_ count: Int) -> Single<[Seeder]>
}

extension SeedersApi {
    public func getSeeder(byAccountId id: ChainObject) -> Single<Seeder> {
        return GetSeeder(id).base.toResponse(api.core)
    }
    
    public func listSeedersByPrice(_ count: Int = 100) -> Single<[Seeder]> {
        return ListSeedersByPrice(count).base.toResponse(api.core)
    }
    
    public func listSeedersByUpload(_ count: Int = 100) -> Single<[Seeder]> {
        return ListSeedersByUpload(count).base.toResponse(api.core)
    }
    
    public func listSeedersByRegion(_ region: String = Regions.ALL.code) -> Single<[Seeder]> {
        return ListSeedersByRegion(region).base.toResponse(api.core)
    }
    
    public func listSeedersByRating(_ count: Int = 100) -> Single<[Seeder]> {
        return ListSeedersByRating(count).base.toResponse(api.core)
    }
}

extension ApiProvider: SeedersApi {}
