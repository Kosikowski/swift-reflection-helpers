//
//  toDotDict.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//
//  Converts any nested value/object into a flattened dictionary using dot notation keys.
//  Example use case:
//
//      struct User { var name: String; var address: Address }
//      struct Address { var city: String; var zip: Int }
//      let user = User(name: "John", address: Address(city: "London", zip: 12345))
//      let flat = toDotDict(user)
//      // flat: ["name": "John", "address.city": "London", "address.zip": 12345]
//

/// Recursively flattens any Swift value/object into a dictionary with dot-separated keys for nested properties.
/// - Parameters:
///   - any: The value to flatten. Can be any type.
///   - prefix: Used internally for recursion to build the dot-separated key path.
/// - Returns: A dictionary mapping dot key paths to leaf values.
func toDotDict(_ any: Any, prefix: String = "") -> [String: Any] {
    var dict: [String: Any] = [:] // Final result
    let m = Mirror(reflecting: any) // Reflect on the value at runtime

    if m.children.isEmpty { // Base case: value has no children (a leaf scalar or simple value)
        dict[prefix] = any // Use the accumulated prefix as the key
    } else {
        // Recursive case: value has properties/children
        for child in m.children {
            guard let label = child.label else { continue } // Skip unnamed children
            // Build the new key: if prefix is empty, use just the property; otherwise, dot-separate
            let key = prefix.isEmpty ? label : "\(prefix).\(label)"
            // Merge the flattened dictionary from the child into the result
            dict.merge(toDotDict(child.value, prefix: key)) { $1 }
        }
    }
    return dict
}
