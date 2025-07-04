//
//  sortBy.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

/// Utilities for sorting arrays by a property name using Swift reflection.
///
/// Provides a generic function and an Array extension for sorting elements based on the runtime value of a specified property.
///
/// - Only properties conforming to Comparable will be sorted.
/// - Reflection adds overhead; for performance-critical code, prefer direct property access.
/// - If a property isn't found or isn't Comparable, sorting falls back to the original order for those elements.
///

import Foundation

extension Comparable {
    /// Type-erased comparison for Comparable values, bridging to ComparisonResult.
    ///
    /// Returns .orderedSame if the input isn't the same type as self.
    func compareTo(other: Any) -> ComparisonResult {
        guard let other = other as? Self else {
            return .orderedSame
        }
        if self < other { return .orderedAscending }
        if self > other { return .orderedDescending }
        return .orderedSame
    }
}

/// Sorts an array in place by the value of a property with the given name using reflection.
/// - Parameters:
///   - key: Property name for sorting. Must match a property on all elements.
///   - array: The array to sort in place.
///
/// The property value must conform to Comparable. If the property isn't found or isn't Comparable, those elements retain their relative order.
///
/// - Performance: Reflection is slower than direct property access. Use for dynamic property names only when necessary.
///
/// Example:
/// ```swift
/// struct Person { let name: String; let age: Int }
/// var people = [Person(name: "Alice", age: 30), Person(name: "Bob", age: 25)]
/// sortBy("age", array: &people)
/// ```
func sortBy<T>(_ key: String, array: inout [T]) {
    array.sort {
        guard
            let l = value(of: $0, whereName: { $0 == key }),
            let r = value(of: $1, whereName: { $0 == key }),
            type(of: l) == type(of: r)
        else {
            // If either property value isn't found or types don't match, keep original order
            return false
        }

        // Attempt to compare if the property type conforms to Comparable
        switch l {
        case let left as any Comparable:
            // Safe to force-cast r now, since we know the types match
            let right = r as! (any Comparable)
            // Use type-erased comparison
            return left.compareTo(other: right) == .orderedAscending
        default:
            return false
        }
    }
}

/// Sorts the array in place by a property name using reflection.
/// - Parameter key: The name of the property to sort by.
///
/// The property value must conform to Comparable. If the property isn't found or isn't Comparable, those elements retain their original order.
///
/// Example:
/// ```swift
/// struct Person { let name: String; let age: Int }
/// var people = [Person(name: "Alice", age: 30), Person(name: "Bob", age: 25)]
/// people.sortBy("age")
/// ```
extension Array {
    /// Sorts the array in place by a property name using reflection.
    /// - Parameter key: The name of the property to sort by.
    mutating func sortBy(_ key: String) {
        sort {
            // Reflect on each element and look for a child with the matching property name
            guard
                let l = Mirror(reflecting: $0).children.first(where: { $0.label == key })?.value,
                let r = Mirror(reflecting: $1).children.first(where: { $0.label == key })?.value,
                type(of: l) == type(of: r)
            else {
                // If property not found or types don't match, retain existing order
                return false
            }
            // Attempt to compare if the property type conforms to Comparable
            switch l {
            case let left as any Comparable:
                let right = r as! (any Comparable)
                return left.compareTo(other: right) == .orderedAscending
            default:
                return false
            }
        }
    }
}
