//
//  keyPath.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Foundation

/// Swift (as of 2025) cannot create key paths from property names at runtime for structs/classes in a generic way.
/// You must provide the mapping per-type. Use this protocol on types you want key path inspection for.
protocol KeyPathIterable {
    /// Returns `[String: AnyKeyPath]` mapping stored-property names to key paths.
    static var allKeyPaths: [String: AnyKeyPath] { get }
}

// Example usage:
//
// struct User: KeyPathIterable {
//     var name: String
//     var age: Int
//
//     static let allKeyPaths: [String: AnyKeyPath] = [
//         "name": \User.name,
//         "age": \User.age
//     ]
// }
//
// You can now use User.allKeyPaths to access properties dynamically.
