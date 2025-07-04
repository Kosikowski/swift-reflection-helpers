//
//  injectable.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//
import Foundation

/*
 Generates a Graphviz DOT representation of any tree-like structure.

 - Parameters:
    - root: The root node of a tree conforming to `TreeLike`.
 - Returns: A string in DOT format, suitable for piping into Graphviz for visualization.

 Usage Example:

    struct Node: TreeLike, CustomStringConvertible {
        var value: String
        var children: [Node]
        var description: String { value }
    }

    let tree = Node(value: "A", children: [
        Node(value: "B", children: []),
        Node(value: "C", children: [
            Node(value: "D", children: [])
        ])
    ])

    print(dot(tree))
    // Output can be piped into Graphviz:
    //   swift run | dot -Tpng -o tree.png
 */

func dot<T: TreeLike>(_ root: T) -> String {
    // Start the DOT graph declaration
    var lines = ["digraph G {"]

    // Recursively walk the tree and add edges
    func walk(_ parent: T) {
        // For every child node, add an edge and recurse
        for child in Mirror(reflecting: parent).children.compactMap({ $0.value as? T }) {
            lines.append("  \"\(parent)\" -> \"\(child)\";")
            walk(child)
        }
    }
    walk(root)
    // Close the DOT graph declaration
    lines.append("}")
    // Return the DOT representation as a single string
    return lines.joined(separator: "\n")
}
