@testable import swift_reflection_helpers
import Testing

@Suite("TreeLike: DFS and BFS traversal")
struct TreeLikeTests {
    struct Node: TreeLike, Equatable {
        let value: Int
        let children: [Node]
    }

    let tree = Node(value: 1, children: [
        Node(value: 2, children: []),
        Node(value: 3, children: [Node(value: 5, children: [])]),
        Node(value: 4, children: []),
    ])

    @Test("Depth-first traversal (flattenedDFS)")
    func testDFS() async throws {
        let dfs = tree.flattenedDFS().map { (node: Node) in node.value }
        #expect(dfs == [1, 2, 3, 5, 4])
    }

    @Test("Breadth-first traversal (levels)")
    func testBFSLevels() async throws {
        let bfs = tree.levels().map { (level: [Node]) in level.map { (node: Node) in node.value } }
        #expect(bfs == [[1], [2, 3, 4], [5]])
    }

    @Test("Single node tree")
    func testSingleNode() async throws {
        let root = Node(value: 999, children: [])
        #expect(root.flattenedDFS().map { (node: Node) in node.value } == [999])
        #expect(root.levels().map { (level: [Node]) in level.map { (node: Node) in node.value } } == [[999]])
    }
}
