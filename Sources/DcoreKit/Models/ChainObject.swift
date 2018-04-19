
//
//  ChainObject.swift
//  DcoreKit
//
//  Created by Michal Grman on 18/04/2018.
//

import Foundation
import CryptoSwift

public struct ChainObject: Hashable, Codable {
    
    public static let None = "0.0.0".toChainObject()
    
    public var hashValue: Int { return 0 }
    
    public init(from decoder: Decoder) throws {
        
    }
}

extension ChainObject: ByteSerializable {
    public var bytes: Data {
        return Data([])
    }
}

extension String {
    
    public func toChainObject() -> ChainObject {
        fatalError("Not implemented")
    }
}
