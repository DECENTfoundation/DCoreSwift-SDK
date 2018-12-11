import Foundation

class ListSeedersByUpload: BaseRequest<[Seeder]> {
    
    required init(count: Int = 100) {
        super.init(api: .DATABASE, method: "list_seeders_by_upload", returnClass: [Seeder].self, params: [count])
    }
}

