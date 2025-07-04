//
//  keyPath.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Foundation

/*
 Dynamic creation of key paths from property names at runtime is not possible in Swift due to its static type system.

 Instead, to enable iteration over a type's key paths, you can adopt a protocol that requires
 an explicit dictionary mapping property names to their key paths.

 Example:

 protocol KeyPathIterable {
     static var allKeyPaths: [String: AnyKeyPath] { get }
 }

 struct User: KeyPathIterable {
     var name: String
     var age: Int

     static let allKeyPaths: [String: AnyKeyPath] = [
         "name": \User.name,
         "age": \User.age
     ]
 }

 This approach provides a type-safe and explicit way to access properties dynamically.
 */
//
// func keyPaths<T: DefaultInitializable>(_ type: T.Type) -> [String: AnyKeyPath] {
//    Mirror(reflecting: type.init())
//        .children
//        .compactMap { child in
//            guard let name = child.label else { return nil }
//            return (name, \T.self[keyPath: name]) //via reflection
//        }
//        .reduce(into: [:]) { $0[$1.0] = $1.1 }
// }
