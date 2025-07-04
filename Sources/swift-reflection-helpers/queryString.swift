//
//  queryString.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

func queryString<T>(_ params: T) -> String {
    Mirror(reflecting: params)
        .children
        .compactMap { child -> String? in
            guard let k = child.label else { return nil }
            return "\(k)=\(child.value)"
        }
        .joined(separator: "&")
}
