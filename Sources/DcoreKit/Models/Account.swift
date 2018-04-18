//
//  Account.swift
//  DcoreKit
//
//  Created by Michal Grman on 18/04/2018.
//

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
        case id
        case registrar
        case name
        case owner
        case active
        case options
        case statistics
        case rightsToPublish = "rights_to_publish"
        case topControlFlags = "top_n_control_flags"
    }
}

extension Account: ByteSerializable {
    public var bytes: Data {
        return Data([])
    }
}
