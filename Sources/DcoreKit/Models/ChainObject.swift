
//
//  ChainObject.swift
//  DcoreKit
//
//  Created by Michal Grman on 18/04/2018.
//

import Foundation

public struct ChainObject: Hashable {
    
    public static let None = "0.0.0".toChainObject()
    
    public var hashValue: Int { return 0 }
    
    
}

extension String {
    
    public func toChainObject() -> ChainObject {
        return ChainObject()
    }
}
