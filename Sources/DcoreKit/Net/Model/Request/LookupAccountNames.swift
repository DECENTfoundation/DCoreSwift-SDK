import Foundation

class LookupAccountNames:  BaseRequest<[Account]> {
    
    required init(_ names: [String]) {
        super.init(.database, api: "lookup_account_names", returnClass: [Account].self, params: [names])
    }
}
