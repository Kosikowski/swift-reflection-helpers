//
//  DeepCopying.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Foundation

/// A protocol for objects that can be deeply copied using reflection.
/// Requires conforming types to be default-initializable.
protocol DeepCopying:DefaultInitializable {}

/// Default implementation of deepCopy for types that conform to DeepCopying.
extension DeepCopying {
    /// Creates a deep copy of the object using runtime reflection.
    /// Recursively copies all properties that also conform to DeepCopying.
    func deepCopy() -> Self {
        // Create a new instance using the default initializer
        let copy = Self()
        // Iterate over all properties using Mirror
        for child in Mirror(reflecting: self).children {
            guard let name = child.label else { continue }
            let value = child.value
            let cloned: Any
            if let dc = value as? DeepCopying { // If property is DeepCopying, recurse
                cloned = dc.deepCopy()
            } else {
                cloned = value // Otherwise, assign as-is (best effort)
            }
            // Set the copied/cloned value on the new instance using KVC
            (copy as AnyObject).setValue(cloned, forKey: name)
        }
        return copy
    }
}
