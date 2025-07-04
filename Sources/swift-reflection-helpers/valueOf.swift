//
//  valueOf.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

/// Returns the value of the first property whose *name* matches
/// the supplied predicate. Handy in exploratory code.
///
/// - Parameters:
///   - object: An instance whose properties will be inspected.
///   - matches: A closure that takes a property name and returns true if it matches the search criteria.
/// - Returns: The value of the first matching property, or nil if none is found.
func value<T>(of object: T, whereName matches: (String) -> Bool) -> Any? {
    // Use Swift's Mirror API to inspect the properties (children) of the object
    Mirror(reflecting: object).children.first { child in
        // For each property, check if it has a label (name) and if it matches the predicate
        child.label.map(matches) ?? false
    }?.value // If a matching property is found, return its value; otherwise, return nil
}

/*
 // Example usage:
 struct Person {
     let firstName: String
     let lastName: String
     let age: Int
 }

 let person = Person(firstName: "Alice", lastName: "Smith", age: 30)
 // Find the value of the property whose name is exactly "lastName":
 let lastNameValue = value(of: person) { $0 == "lastName" }
 print(lastNameValue ?? "Not found") // Output: Smith
 */
