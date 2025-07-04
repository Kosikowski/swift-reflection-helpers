//
//  CustomStringConvertible+Extensions.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 01/07/2025.
//

/**
 This extension provides an automatic, reflection-based implementation of the `description` property for any type conforming to `CustomStringConvertible`.

 It uses Swift's `Mirror` API to introspect the properties of the instance at runtime and generate a string representation listing all property names and their values.

 This can be particularly useful for debugging or logging purposes when you want a quick, consistent textual representation of your types without manually implementing `description`.

 **Caveats:**
 - The output depends on runtime reflection and may have performance implications if used extensively.
 - Properties without labels (such as tuple elements) are represented with an underscore (`_`) as the key.
 - This implementation assumes the conforming type has stored properties and may not capture computed properties without backing storage.
 */

import Foundation

/// Provides a default reflection-based implementation of the `description` property for any type conforming to `CustomStringConvertible`.
public extension CustomStringConvertible {
    /// A textual representation of the instance, generated by reflecting all its stored properties.
    ///
    /// This implementation uses Swift's `Mirror` API to enumerate all properties of the instance,
    /// formats each as a key-value pair (`propertyName: propertyValue`), and joins them with commas.
    /// Use this to automatically provide a detailed description without manual string construction.
    var description: String {
        // Reflect the current instance to access its properties dynamically.
        let mirror = Mirror(reflecting: self)

        // Map each child property to a "label: value" string.
        // If the property has no label, use "_" as a placeholder.
        let keyValuePairs = mirror.children.map { child in
            let key = child.label ?? "_"
            let value = child.value
            return "\(key): \(value)"
        }

        // Join all key-value pairs with a comma and space separator to form the final description.
        return keyValuePairs.joined(separator: ", ")
    }
}
