import Foundation

class ListSeedersByRating: BaseRequest<[Seeder]> {
 
    required init(count: Int = 100) {
        super.init(api: .DATABASE, method: "list_seeders_by_rating", returnClass: [Seeder].self, params: [count])
    }
}
