//
//  sortBy.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//
/// This file provides utilities to sort arrays by a property name using Swift's reflection capabilities.
/// It includes a generic function and an Array extension that enable sorting elements based on the value
/// of a specified property key, which is determined at runtime.
/// 
/// These utilities rely on the property values conforming to Comparable for sorting purposes.
/// Since they use reflection, they may have performance implications compared to compile-time property access.
/// Additionally, sorting will silently fail (default to returning false) if the property cannot be found
/// or if the property values are not Comparable.

import Foundation

/// Sorts the given array in place based on the value of a property with the specified name.
/// - Parameters:
///   - key: The name of the property to sort by. This should be an exact property name of the elements in the array.
///   - array: The array of generic type T to be sorted in place.
/// 
/// This function uses reflection to access the property values by name on each element at runtime.
/// The property values must conform to Comparable, otherwise the sorting will not reorder those elements.
/// 
/// Limitations:
/// - If the property name does not exist on an element, the comparison defaults to false, which may lead to
///   unexpected orderings.
/// - Reflection-based access is less performant than direct property access.
/// - The function assumes homogeneous arrays where all elements have the property.
/// 
/// Usage example:
/// ```swift
/// struct Person {
///   let name: String
///   let age: Int
/// }
/// var people = [Person(name: "Alice", age: 30), Person(name: "Bob", age: 25)]
/// sortBy("age", array: &people)
/// ```

//func sortBy<T>(_ key: String, array: inout [T]) {
//    array.sort {
//        guard
//            // Access the property value of the left element using reflection and cast it to Comparable
//            let l = value(of: $0, whereName: { $0 == key }) as? Comparable,
//            // Access the property value of the right element similarly
//            let r = value(of: $1, whereName: { $0 == key }) as? Comparable
//        else { 
//            // If either property value isn't found or not Comparable, keep original order for these elements
//            return false 
//        }
//        return l < r
//    }
//}

/// An extension on Array to provide an instance method for sorting by a property name using reflection.
/// This method sorts the array in place by comparing the values of a property with a given key.
/// 
/// Note:
/// - The property values must conform to Comparable.
/// - If the property is not found or values cannot be cast to Comparable, those comparisons return false,
///   which can lead to partial or no sorting.
/// - Reflection may impact performance compared to direct sorting with closures.
/// 
/// Usage example:
/// ```swift
/// struct Person {
///   let name: String
///   let age: Int
/// }
/// var people = [Person(name: "Alice", age: 30), Person(name: "Bob", age: 25)]
/// people.sortBy("age")
/// ```



//extension Array {
//    /// Sorts the array in place by a property name using reflection.
//    /// - Parameter key: The name of the property to sort by.
//    mutating func sortBy(_ key: String) {
//        sort {
//            // Reflect on the first element and look for a child with the matching property name
//            guard
//                let l = Mirror(reflecting: $0).children.first(where: { $0.label == key })?.value as? Comparable,
//                let r = Mirror(reflecting: $1).children.first(where: { $0.label == key })?.value as? Comparable
//            else {
//                // If property not found or not Comparable, retain existing order for these elements
//                return false
//            }
//            return l < r
//        }
//    }
//}
