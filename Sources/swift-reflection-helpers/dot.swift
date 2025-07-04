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
    var lines = ["digraph G {"]

    func walk(_ parent: T) {
        for child in Mirror(reflecting: parent).children {
            switch child.value {
            case let c as T:
                lines.append("  \"\(parent)\" -> \"\(c)\";")
                walk(c)
            case let arr as [T]:
                for c in arr {
                    lines.append("  \"\(parent)\" -> \"\(c)\";")
                    walk(c)
                }
            default:
                continue
            }
        }
    }
    walk(root)
    lines.append("}")
    return lines.joined(separator: "\n")
}
