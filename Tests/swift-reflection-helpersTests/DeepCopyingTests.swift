import XCTest

@testable import swift_reflection_helpers

// Minimal DefaultInitializable definition for testing
public protocol DefaultInitializable {
    init()
}

// A sample class for testing deep copying
final class Node: DeepCopying, DefaultInitializable {
    var value: Int
    var child: Node?
    required init() {
        value = 0
        child = nil
    }

    init(value: Int, child: Node? = nil) {
        self.value = value
        self.child = child
    }

    func deepCopy() -> Node {
        return Node(value: value, child: child?.deepCopy())
    }
}

final class DeepCopyingTests: XCTestCase {
    func testSimpleDeepCopy() {
        let original = Node(value: 5)
        let copy = original.deepCopy()
        XCTAssertFalse(copy === original)
        XCTAssertEqual(copy.value, original.value)
    }

    func testRecursiveDeepCopy() {
        let child = Node(value: 10)
        let parent = Node(value: 3, child: child)
        let copy = parent.deepCopy()
        XCTAssertFalse(copy === parent)
        XCTAssertFalse(copy.child === parent.child)
        XCTAssertEqual(copy.child?.value, 10)
    }

    func testCopyIndependence() {
        let original = Node(value: 1, child: Node(value: 2))
        let copy = original.deepCopy()
        copy.value = 100
        copy.child?.value = 200
        XCTAssertEqual(original.value, 1)
        XCTAssertEqual(original.child?.value, 2)
    }
}
