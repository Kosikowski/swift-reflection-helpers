//
//  DeepCopying.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Foundation

protocol DeepCopying:DefaultInitializable {}

extension DeepCopying {
    func deepCopy() -> Self {
        let copy = Self()
        for child in Mirror(reflecting: self).children {
            guard let name = child.label else { continue }
            let value = child.value
            let cloned: Any
            if let dc = value as? DeepCopying { // recurse
                cloned = dc.deepCopy()
            } else {
                cloned = value // best effort
            }
            (copy as AnyObject).setValue(cloned, forKey: name)
        }
        return copy
    }
}
