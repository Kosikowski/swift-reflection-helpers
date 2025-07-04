//
//  valueOf.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

/// Returns the value of the first property whose *name* matches
/// the supplied predicate. Handy in exploratory code.
func value<T>(of object: T, whereName matches: (String) -> Bool) -> Any? {
    Mirror(reflecting: object).children.first { child in
        child.label.map(matches) ?? false
    }?.value
}
