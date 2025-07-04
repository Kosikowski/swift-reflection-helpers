//
//  DefaultsStorable.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Foundation

/// Protocol to allow conforming types to be saved to and loaded from UserDefaults.
protocol DefaultsStorable { init() }

/// Provides default implementation for saving and loading conforming types to/from UserDefaults.
extension DefaultsStorable {
    /// The UserDefaults instance used for storing and retrieving data.
    private static var suite: UserDefaults { .standard }

    /// A unique prefix for keys, based on the conforming type name.
    private static var keyPrefix: String { String(describing: Self.self) + "." }

    /// Saves all properties of the conforming type to UserDefaults.
    func saveToDefaults() {
        let defaults = Self.suite
        // Reflect over all properties of self
        for child in Mirror(reflecting: self).children {
            guard let k = child.label else { continue }
            // Save each property value to UserDefaults with a unique key
            defaults.set(child.value, forKey: Self.keyPrefix + k)
        }
    }

    /// Loads properties from UserDefaults and returns a new instance with those values.
    static func loadFromDefaults() -> Self {
        let obj = Self()
        let defaults = suite
        // Reflect over all properties of the new instance
        for child in Mirror(reflecting: obj).children {
            guard let k = child.label else { continue }
            // Attempt to retrieve stored value from UserDefaults
            if let val = defaults.object(forKey: keyPrefix + k) {
                // Set the value on the object using KVC
                (obj as AnyObject).setValue(val, forKey: k)
            }
        }
        return obj
    }
}
