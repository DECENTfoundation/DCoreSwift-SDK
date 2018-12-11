import Foundation

class LookupMiners: BaseRequest<[String:ChainObject]> {
    
    required init(lowerBound: String, limit: Int = 1000) {
        super.init(api: .DATABASE, method: "lookup_miners", returnClass: [String:ChainObject].self, params: [lowerBound, limit])
    }
}
