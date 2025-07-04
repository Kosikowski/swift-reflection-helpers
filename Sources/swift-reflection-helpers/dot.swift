//
//  injectable.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//
import Foundation

// Pipe the output to Graphviz and you’ve got a visual.
func dot<T: TreeLike>(_ root: T) -> String {
    var lines = ["digraph G {"]
    func walk(_ parent: T) {
        for child in Mirror(reflecting: parent).children.compactMap({ $0.value as? T }) {
            lines.append("  \"\(parent)\" -> \"\(child)\";")
            walk(child)
        }
    }
    walk(root)
    lines.append("}")
    return lines.joined(separator: "\n")
}
