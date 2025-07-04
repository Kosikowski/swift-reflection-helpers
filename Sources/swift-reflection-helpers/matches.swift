//
//  natcges.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Foundation

/// Returns `true` if ANY stored property (or element of a collection)
/// contains the query string when converted to text.
func matches<T>(_ value: T, query: String) -> Bool {
    let lower = query.lowercased()

    // Recurse through the value graph
    func walk(_ any: Any) -> Bool {
        switch any {
        case let str as String:
            return str.lowercased().contains(lower)
        case let n as CustomStringConvertible:
            return "\(n)".lowercased().contains(lower)
        default:
            for child in Mirror(reflecting: any).children {
                if walk(child.value) { return true }
            }
            return false
        }
    }
    return walk(value)
}
