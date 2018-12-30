import Foundation

class LookupMiners: BaseRequest<[String:ChainObject]> {
    
    required init(lowerBound: String, limit: Int = 1000) {
        super.init(.database, api: "lookup_miners", returnClass: [String:ChainObject].self, params: [lowerBound, limit])
    }
}
