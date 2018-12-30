import Foundation

class ListSeedersByRating: BaseRequest<[Seeder]> {
 
    required init(count: Int = 100) {
        super.init(.database, api: "list_seeders_by_rating", returnClass: [Seeder].self, params: [count])
    }
}
