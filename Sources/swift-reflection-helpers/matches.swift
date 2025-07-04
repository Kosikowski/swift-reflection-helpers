//
//  matches.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Foundation

/// Returns `true` if ANY stored property (or element of a collection) of `value` contains the `query` string when converted to text.
///
/// This function uses reflection to recursively inspect all stored properties and collection elements of the given value.
/// The comparison is case-insensitive and will convert each value to a string (using `CustomStringConvertible`) before searching.
///
/// - Parameters:
///   - value: The value (any type) to search within.
///   - query: The query string to search for (case-insensitive).
/// - Returns: `true` if any property or element contains the query; otherwise, `false`.
func matches<T>(_ value: T, query: String) -> Bool {
    let lower = query.lowercased() // Normalize the query for case-insensitive comparison

    // Recursively walk through the value graph using reflection
    func walk(_ any: Any) -> Bool {
        switch any {
        case let str as String:
            // Direct string: check for substring presence
            return str.lowercased().contains(lower)
        case let n as CustomStringConvertible:
            // Any value convertible to string: check its textual representation
            return "\(n)".lowercased().contains(lower)
        default:
            // For structs, classes, enums, arrays, dictionaries, etc.
            for child in Mirror(reflecting: any).children {
                if walk(child.value) { return true } // Recursively search each property/element
            }
            return false
        }
    }
    return walk(value)
}

/*
 USAGE EXAMPLE:

 struct Person {
     let name: String
     let age: Int
     let tags: [String]
 }

 let person = Person(name: "Alice Smith", age: 34, tags: ["engineer", "swift"])

 matches(person, query: "swift")  // true
 matches(person, query: "alice")  // true
 matches(person, query: "35")     // false
 */
