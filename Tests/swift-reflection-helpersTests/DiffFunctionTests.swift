@testable import swift_reflection_helpers
import Testing

@Suite("diff(_:_:) detects property changes between two objects")
struct DiffFunctionTests {
    struct Person {
        var name: String
        var age: Int
        var active: Bool
    }

    @Test("Returns changed properties as a dictionary")
    func testDetectsChangedProperties() async throws {
        let old = Person(name: "Alice", age: 30, active: true)
        let updated = Person(name: "Alice", age: 31, active: false)
        let changes = diff(old, updated)
        #expect(changes["age"] as? Int == 31)
        #expect(changes["active"] as? Bool == false)
        #expect(changes["name"] == nil)
    }

    @Test("Returns empty dict when nothing changed")
    func testDetectsNoChanges() async throws {
        let old = Person(name: "Bob", age: 20, active: false)
        let updated = Person(name: "Bob", age: 20, active: false)
        let changes = diff(old, updated)
        #expect(changes.isEmpty)
    }

    struct Empty {}
    @Test("Returns empty dict for empty structs")
    func testEmptyStruct() async throws {
        let old = Empty()
        let updated = Empty()
        let changes = diff(old, updated)
        #expect(changes.isEmpty)
    }
}
