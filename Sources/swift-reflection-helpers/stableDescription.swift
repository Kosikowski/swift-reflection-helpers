//
//  stableDescription.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Foundation

func stableDescription<T>(_ value: T) -> String {
    Mirror(reflecting: value)
        .children
        .compactMap { child -> (String, String)? in
            guard let label = child.label else { return nil }
            return (label, "\(child.value)")
        }
        .sorted { $0.0 < $1.0 }
        .map { "\($0)=\($1)" }
        .joined(separator: "\n")
}
