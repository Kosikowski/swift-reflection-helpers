//
//  fuzz.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Foundation

/// Returns a new instance with randomised fields.
/// Add cases as needed for domain types.
///
/// Uses reflection to inspect each child (property) of the input instance.
/// If the property is of a recognized type (Int, Double, Bool, String), it assigns a random value.
/// For unknown types, it leaves the property unchanged.
/// Limitations: Only works for reference types (classes) that support KVC (Key-Value Coding).
///
/// - Parameter proto: An instance to randomize (usually a class instance).
/// - Returns: A copy of the input with randomized fields where possible.
func fuzz<T>(_ proto: T) -> T {
    let copy = proto
    // Iterate over all properties (children) using reflection
    for child in Mirror(reflecting: proto).children {
        guard let name = child.label else { continue }
        // Generate a random value based on property type
        let newVal: Any = {
            switch child.value {
            case is Int: return Int.random(in: 0 ... 1000)
            case is Double: return Double.random(in: 0 ... 1000) / 10
            case is Bool: return Bool.random()
            case is String: return String(UUID().uuidString.prefix(8))
            default: return child.value // leave unknowns unchanged
            }
        }()
        // Set the new value for the property (KVC for classes)
        (copy as AnyObject).setValue(newVal, forKey: name)
    }
    return copy
}

/*
 // Example usage:
 class Example {
     @objc var x: Int = 1
     @objc var y: Double = 3.14
     @objc var flag: Bool = false
     @objc var label: String = "test"
 }

 let original = Example()
 let randomized = fuzz(original)
 print(randomized.x, randomized.y, randomized.flag, randomized.label)
 */
