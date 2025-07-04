@testable import swift_reflection_helpers
import Testing

private struct NodeT: TreeLike, CustomStringConvertible {
    var value: String
    var children: [NodeT]
    var description: String { value }
}

@Suite("dot(_:) outputs Graphviz representations of trees")
struct DotFunctionTests {
    @Test("Single node tree")
    func testSingleNode() async throws {
        let root = NodeT(value: "Root", children: [])
        let output = dot(root)
        let expected = "digraph G {\n}" // Single node, no edges
        // Matching complete output for full coverage
        #expect(output == expected)
    }

    @Test("Tree with children produces edges")
    func testEdgesPrinted() async throws {
        let root = NodeT(value: "A", children: [
            NodeT(value: "B", children: []),
            NodeT(value: "C", children: [NodeT(value: "D", children: [])]),
        ])
        let output = dot(root)
        // The function outputs nodes in order of discovery (DFS pre-order), so expected DOT:
        let expected = "digraph G {\n  \"A\" -> \"B\";\n  \"A\" -> \"C\";\n  \"C\" -> \"D\";\n}"
        // Exact match ensures correct structure, edges, and formatting
        #expect(output == expected)
    }
}
