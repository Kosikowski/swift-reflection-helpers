//
//  TreeLike.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

/// A tiny protocol so callers can tag the root type.
/// Nothing else is required—`Mirror` does the discovery.
protocol TreeLike {}

extension TreeLike {
    /// Returns every node reachable from `self` (inclusive) in DFS order.
    /// It discovers children *dynamically* by reflection, so you can use
    /// `left / right`, `children: [Node]`, or any other stored property
    /// whose element type also conforms to `TreeLike`.
    func flattenedDFS<T: TreeLike>() -> [T] {
        var out: [T] = []
        func walk(_ node: T) {
            out.append(node) // pre-order
            for child in Mirror(reflecting: node).children {
                switch child.value {
                case let c as T: // single child
                    walk(c)
                case let arr as [T]: // array of children
                    arr.forEach(walk)
                default: break
                }
            }
        }
        walk(self as! T)
        return out
    }
}

extension TreeLike {
    /// Breadth-first walk that groups siblings per level.
    func levels<T: TreeLike>() -> [[T]] {
        var result: [[T]] = []
        var queue: [T] = [self as! T]

        while !queue.isEmpty {
            result.append(queue)
            queue = queue.flatMap { node in
                Mirror(reflecting: node).children.compactMap {
                    // accept either single-child or [T]
                    switch $0.value {
                    case let c as T: return [c]
                    case let arr as [T]: return arr
                    default: return []
                    }
                }.flatMap { $0 }
            }
        }
        return result
    }
}
