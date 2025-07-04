//
//  diff.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Combine
import Foundation

func diff<T>(_ old: T, _ new: T) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues:
        zip(Mirror(reflecting: old).children, Mirror(reflecting: new).children)
            .compactMap { oldChild, newChild in
                guard let label = oldChild.label, "\(oldChild.value)" != "\(newChild.value)" else { return nil }
                return (label, newChild.value)
            }
    )
}
