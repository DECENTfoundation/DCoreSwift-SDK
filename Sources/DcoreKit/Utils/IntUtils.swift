//
//  IntUtils.swift
//  DcoreKit
//
//  Created by Michal Grman on 18/04/2018.
//

import Foundation

extension Int: ByteSerializable {
    
    public var bytes: Data {
        var value = self
        return Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
    }
}

