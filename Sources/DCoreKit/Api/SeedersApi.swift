import Foundation
import RxSwift

public protocol SeedersApi: BaseApi {
    /**
     Get a seeder by id.
     
     - Parameter id: Seeder account object id, eg. 1.2.*,
     as `ChainObject` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if no matching was found.
     
     - Returns: `Seeder`.
     */
    func get(byAccountId id: ChainObjectConvertible) -> Single<Seeder>
    
    /**
     Get a list of seeders by price, in increasing order.
     
     - Parameter limit: Number of items to retrieve,
     max/default `100`.
    
     - Returns: Array `[Seeder]` of seeders.
     */
    func getAllSortedByPrice(_ limit: Int) -> Single<[Seeder]>
    
    /**
     Get a list of seeders ordered by total upload, in decreasing order.
     
     - Parameter limit: Number of items to retrieve,
     max/default `100`.
     
     - Returns: Array `[Seeder]` of seeders.
     */
    func getAllSortedByUpload(_ limit: Int) -> Single<[Seeder]>
    
    /**
     Get a list of seeders by rating, in decreasing order.
     
     - Parameter limit: Number of items to retrieve,
     max/default `100`.
     
     - Returns: Array `[Seeder]` of seeders.
     */
    func getAllSortedByRating(_ limit: Int) -> Single<[Seeder]>
    
    /**
      Get a list of seeders by region.
     
     - Parameter region: Region code, default `Regions.all.code`.
     
     - Returns: Array `[Seeder]` of seeders.
     */
    func getAll(byRegion region: String) -> Single<[Seeder]>
    
}

extension SeedersApi {
    public func get(byAccountId id: ChainObjectConvertible) -> Single<Seeder> {
        return Single.deferred {
            return GetSeeder(try id.asChainObject()).base.toResponse(self.api.core)
        }
    }
    
    public func getAllSortedByPrice(_ limit: Int = DCore.Limits.seeders) -> Single<[Seeder]> {
        return Single.deferred {
            return ListSeedersByPrice(try limit.limited(by: DCore.Limits.seeders)).base.toResponse(self.api.core)
        }
    }
    
    public func getAllSortedByUpload(_ limit: Int = DCore.Limits.seeders) -> Single<[Seeder]> {
        return Single.deferred {
            return ListSeedersByUpload(try limit.limited(by: DCore.Limits.seeders)).base.toResponse(self.api.core)
        }
    }
    
    public func getAllSortedByRating(_ limit: Int = DCore.Limits.seeders) -> Single<[Seeder]> {
        return Single.deferred {
            return ListSeedersByRating(try limit.limited(by: DCore.Limits.seeders)).base.toResponse(self.api.core)
        }
    }
    
    public func getAll(byRegion region: String = Regions.all.code) -> Single<[Seeder]> {
        return ListSeedersByRegion(region).base.toResponse(api.core)
    }
}

extension ApiProvider: SeedersApi {}
