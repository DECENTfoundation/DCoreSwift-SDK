import Foundation

class ListSeedersByPrice: BaseRequest<[Seeder]> {
    
    required init(count: Int = 100) {
        super.init(api: .DATABASE, method: "list_seeders_by_price", returnClass: [Seeder].self, params: [count])
    }
}
