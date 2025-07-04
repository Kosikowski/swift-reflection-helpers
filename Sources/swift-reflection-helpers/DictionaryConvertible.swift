//
//  DictionaryConvertible.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//
import Foundation

// MARK: - DictionaryConvertible Protocol

/// A protocol that allows conforming types to be easily converted to a dictionary representation.
/// This is particularly useful for debugging, serialization, or other reflection-based operations.
protocol DictionaryConvertible {}

// MARK: - DictionaryConvertible Extension

extension DictionaryConvertible {
    /// Converts the conforming instance to a dictionary where property names are keys and their values are dictionary values.
    /// Uses Swift's Mirror API for reflection.
    var asDictionary: [String: Any] {
        Mirror(reflecting: self)
            .children.reduce(into: [:]) { dict, child in
                if let key = child.label { dict[key] = child.value }
            }
    }
}

/*
 // MARK: - Usage Example
 struct User: DictionaryConvertible {
     let name: String
     let age: Int
 }

 let user = User(name: "Alice", age: 30)
 print(user.asDictionary)
 // Output: ["name": "Alice", "age": 30]
 */
