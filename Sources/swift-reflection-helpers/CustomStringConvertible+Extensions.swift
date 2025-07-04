//
//  CustomStringConvertible+Extensions.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 01/07/2025.
//

import Foundation

public extension CustomStringConvertible {
    var description: String {
        Mirror(reflecting: self)
            .children
            .map { "\($0.label ?? "_"): \($0.value)" }
            .joined(separator: ", ")
    }
}
