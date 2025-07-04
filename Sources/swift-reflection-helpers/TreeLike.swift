//
//  TreeLike.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

/// # TreeLike: A protocol and helpers for dynamic tree traversal using Swift reflection.
///
/// This protocol lets you tag any type as "tree-like" for easy traversal of its dynamic tree structure using Swift's `Mirror` reflection.
/// You don't need to explicitly maintain child collections or implement tree traversal logic—the included helpers find children dynamically.
///
/// - Use `flattenedDFS()` for depth-first traversal (pre-order).
/// - Use `levels()` for breadth-first traversal, grouping nodes by level.

/// Use this protocol to tag your root type as supporting generic tree traversal.
/// No required properties or methods—reflection finds children at runtime.
protocol TreeLike {}

extension TreeLike {
    /// Depth-first traversal (pre-order) that returns every reachable node of type `T`.
    /// - Returns: All nodes of type `T` reachable from this root, in DFS pre-order.
    /// - Note: Children are found if stored as properties of type `T` or `[T]`.
    func flattenedDFS<T: TreeLike>() -> [T] {
        var out: [T] = []

        // Recursive helper function to walk the tree in DFS pre-order.
        func walk(_ node: T) {
            out.append(node) // Visit node

            // Discover children dynamically
            for child in Mirror(reflecting: node).children {
                switch child.value {
                case let c as T: // Single child node
                    walk(c)
                case let arr as [T]: // Array of child nodes
                    arr.forEach(walk)
                default:
                    break // Ignore other properties
                }
            }
        }

        // Assumes self is of type T, which should be ensured by caller
        walk(self as! T)

        return out
    }
}

extension TreeLike {
    /// Breadth-first traversal; groups nodes by tree level.
    /// - Returns: Array of levels, each level is an array of nodes present at that depth.
    /// - Note: Children are found if stored as properties of type `T` or `[T]`.
    func levels<T: TreeLike>() -> [[T]] {
        var result: [[T]] = []

        var queue: [T] = [self as! T] // Start at root node

        while !queue.isEmpty {
            result.append(queue) // Add this level

            // Build next level from all children
            queue = queue.flatMap { node in
                Mirror(reflecting: node).children.compactMap {
                    switch $0.value {
                    case let c as T:
                        return [c]
                    case let arr as [T]:
                        return arr
                    default:
                        return []
                    }
                }.flatMap { $0 }
            }
        }

        return result
    }
}

// === Example Usage ===
// Here's a simple tree type to illustrate TreeLike traversal:

/// Example: A simple tree node type using TreeLike
struct Node: TreeLike {
    let value: Int
    let children: [Node] // Children can be an array of Node, which is TreeLike
}

// Example tree:
//      1
//    / | \
//   2  3  4
//      |
//      5
// let tree = Node(value: 1, children: [
//    Node(value: 2, children: []),
//    Node(value: 3, children: [Node(value: 5, children: [])]),
//    Node(value: 4, children: []),
// ])
//
//// Depth-first traversal (pre-order): [1, 2, 3, 5, 4]
// let dfsValues = tree.flattenedDFS().map { $0.value }
//// dfsValues == [1, 2, 3, 5, 4]
//
//// Breadth-first levels: [[1], [2, 3, 4], [5]]
// let bfsLevels = tree.levels().map { $0.map { $0.value } }
//// bfsLevels == [[1], [2, 3, 4], [5]]
//
//// (For demonstration/testing, print them)
// print("DFS order: \(dfsValues)")
// print("BFS levels: \(bfsLevels)")
