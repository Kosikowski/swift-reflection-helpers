//
//  DefaultsStorable.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Foundation

protocol DefaultsStorable { init() }
extension DefaultsStorable {
    private static var suite: UserDefaults { .standard }
    private static var keyPrefix: String { String(describing: Self.self) + "." }

    func saveToDefaults() {
        let defaults = Self.suite
        for child in Mirror(reflecting: self).children {
            guard let k = child.label else { continue }
            defaults.set(child.value, forKey: Self.keyPrefix + k)
        }
    }

    static func loadFromDefaults() -> Self {
        var obj = Self()
        let defaults = suite
        for child in Mirror(reflecting: obj).children {
            guard let k = child.label else { continue }
            if let val = defaults.object(forKey: keyPrefix + k) {
                (obj as AnyObject).setValue(val, forKey: k)
            }
        }
        return obj
    }
}
