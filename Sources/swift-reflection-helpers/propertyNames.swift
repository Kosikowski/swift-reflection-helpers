//
//  keyPath.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Foundation

/// Returns a dictionary mapping property names to their default values for a given type.
///
/// The type `T` must conform to `DefaultInitializable`, so that a default instance can be created for reflection.
///
/// - Parameter type: The type to reflect upon.
/// - Returns: A dictionary where each key is a property name and its value is the default value of that property.
///
/// Usage Example:
/// ```swift
/// struct Person: DefaultInitializable {
///     var name: String = ""
///     var age: Int = 0
///     init() {}
/// }
///
/// let props = propertyNames(Person.self)
/// print(props) // ["name": "", "age": 0]
/// ```
func propertyNames<T>(_ type: T.Type) -> [String: Any] where T: DefaultInitializable {
    Mirror(reflecting: type.init())
        .children
        .reduce(into: [String: Any]()) { dict, child in
            guard let name = child.label else { return }
            dict[name] = child.value
        }
}
