import Foundation

class ListSeedersByRegion: BaseRequest<[Seeder]> {
    
    required init(region: String) {
        super.init(.database, api: "list_seeders_by_region", returnClass: [Seeder].self, params: [region])
    }
}
