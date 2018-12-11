import Foundation

class LookupAccountNames:  BaseRequest<[Account]> {
    
    required init(names: [String]) {
        super.init(api: .DATABASE, method: "lookup_account_names", returnClass: [Account].self, params: [names])
    }
}
