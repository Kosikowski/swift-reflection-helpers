//
//  fizz.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Foundation

/// Returns a new instance with randomised fields.
/// Add cases as needed for domain types.
func fuzz<T>(_ proto: T) -> T {
    let copy = proto
    for child in Mirror(reflecting: proto).children {
        guard let name = child.label else { continue }
        let newVal: Any = {
            switch child.value {
            case is Int: return Int.random(in: 0 ... 1000)
            case is Double: return Double.random(in: 0 ... 1000) / 10
            case is Bool: return Bool.random()
            case is String: return UUID().uuidString.prefix(8)
            default: return child.value // leave unknowns unchanged
            }
        }()
        (copy as AnyObject).setValue(newVal, forKey: name)
    }
    return copy
}
