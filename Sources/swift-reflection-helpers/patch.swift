//
//  patch.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

/// Returns an array of (propertyName, newValue) for properties that differ between `old` and `new`.
/// - Parameters:
///   - old: The original value (typically a struct or class instance).
///   - new: The new value to compare to the old value.
/// - Returns: An array of tuples where each tuple contains the property name and its updated value from `new`.
///
/// Note: This uses Swift reflection (Mirror). Property order and labels must match.
func patch<T>(_ old: T, _ new: T) -> [(String, Any)] {
    // Pair up the child properties of both instances using zip
    zip(Mirror(reflecting: old).children,
        Mirror(reflecting: new).children)
        .compactMap { o, n in
            // Only consider properties with a label (i.e., named properties)
            guard let name = o.label else { return nil }
            // Compare values as strings (simple, may not work for all types)
            return "\(o.value)" == "\(n.value)" ? nil : (name, n.value)
        }
}

/*
 // Example use case:

 struct User {
     var name: String
     var age: Int
     var email: String
 }

 let oldUser = User(name: "Alice", age: 30, email: "alice@mail.com")
 let newUser = User(name: "Alice", age: 31, email: "alice@work.com")

 let diffs = patch(oldUser, newUser)
 // diffs will be:
 // [("age", 31), ("email", "alice@work.com")]
 */
