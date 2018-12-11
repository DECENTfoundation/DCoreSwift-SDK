import Foundation

public struct Account: Codable {
    
    public let id: ChainObject
    public let registrar: ChainObject
    public let name: String
    public let owner: Authority
    public let active: Authority
    public let options: Options
    public let rightsToPublish: Publishing
    public let statistics: ChainObject
    public let topControlFlags: Int
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        registrar,
        name,
        owner,
        active,
        options,
        rightsToPublish = "rights_to_publish",
        statistics,
        topControlFlags = "top_n_control_flags"
    }
}

 /*
 companion object {
 private val pattern = Pattern.compile("^[a-z][a-z0-9-]+[a-z0-9](?:\\.[a-z][a-z0-9-]+[a-z0-9])*\$")
 
 fun isValidName(name: String) = pattern.matcher(name).matches() && name.length in 5..63
 }
 */
