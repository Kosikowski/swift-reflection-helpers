//
//  patch.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

func patch<T>(_ old: T, _ new: T) -> [(String, Any)] {
    zip(Mirror(reflecting: old).children,
        Mirror(reflecting: new).children)
        .compactMap { o, n in
            guard let name = o.label else { return nil }
            return "\(o.value)" == "\(n.value)" ? nil : (name, n.value)
        }
}
