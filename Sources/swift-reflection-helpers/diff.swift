//
//  diff.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Combine
import Foundation

/// Returns a dictionary of property names and new values for all properties that have changed between two instances of the same type.
/// - Parameters:
///   - old: The original value.
///   - new: The updated value.
/// - Returns: A [String: Any] dictionary where each key is a property name and value is the new value for changed properties.
func diff<T>(_ old: T, _ new: T) -> [String: Any] {
    // Use Mirror to reflect on the properties of both instances and zip them together
    return Dictionary(uniqueKeysWithValues:
        zip(Mirror(reflecting: old).children, Mirror(reflecting: new).children)
            .compactMap { oldChild, newChild in
                // Only consider properties with a label (i.e., not tuple elements), and where values differ
                guard let label = oldChild.label, "\(oldChild.value)" != "\(newChild.value)" else { return nil }
                // Return a tuple of (propertyName, newValue) for changed properties
                return (label, newChild.value)
            }
    )
}

/*
 // Example Usage:
 struct Person {
     var name: String
     var age: Int
 }

 let original = Person(name: "Alice", age: 30)
 let updated = Person(name: "Alice", age: 31)

 let changes = diff(original, updated)
 print(changes) // Output: ["age": 31]
 */
