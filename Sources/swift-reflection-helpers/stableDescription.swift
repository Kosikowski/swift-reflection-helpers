//
//  stableDescription.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Foundation

/**
 Example usage:

 struct User {
     let id: Int
     let name: String
     let email: String
 }

 let user = User(id: 42, name: "Alice", email: "alice@example.com")
 print(stableDescription(user))
 // Output (order of properties is stable, sorted by name):
 // email=alice@example.com
 // id=42
 // name=Alice
 */

func stableDescription<T>(_ value: T) -> String {
    // Create a Mirror for reflecting over the properties of the value
    Mirror(reflecting: value)
        .children
        // Map each child property to a tuple (label, value as String), skip unnamed children
        .compactMap { child -> (String, String)? in
            guard let label = child.label else { return nil }
            // Convert the child value to String representation
            return (label, "\(child.value)")
        }
        // Sort properties alphabetically by label to ensure stable ordering
        .sorted { $0.0 < $1.0 }
        // Format each property as "label=value" string
        .map { "\($0)=\($1)" }
        // Join all properties with newlines
        .joined(separator: "\n")
}
