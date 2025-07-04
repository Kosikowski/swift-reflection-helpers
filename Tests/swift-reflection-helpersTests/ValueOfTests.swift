@testable import swift_reflection_helpers
import Testing

@Suite("value(of:whereName:): Reflection property lookup")
struct ValueOfTests {
    struct Person {
        let firstName: String
        let lastName: String
        let age: Int
    }

    @Test("Exact match finds property value")
    func testExactMatch() async throws {
        let p = Person(firstName: "Alice", lastName: "Smith", age: 30)
        let lastName = value(of: p) { $0 == "lastName" }
        #expect((lastName as? String) == "Smith")
    }

    @Test("Returns nil for no match")
    func testNoMatchReturnsNil() async throws {
        let p = Person(firstName: "Bob", lastName: "Stone", age: 40)
        let result = value(of: p) { $0 == "notAField" }
        #expect(result == nil)
    }

    @Test("First match wins if multiple")
    func testFirstMatchWins() async throws {
        struct Dups { let foo: Int; let foo2: Int }
        let d = Dups(foo: 11, foo2: 22)
        let found = value(of: d) { $0.hasPrefix("foo") }
        #expect((found as? Int) == 11)
    }

    @Test("Works with reference types")
    func testReferenceType() async throws {
        class Box { let x: Double; init(x: Double) { self.x = x } }
        let b = Box(x: 1.23)
        let val = value(of: b) { $0 == "x" }
        #expect((val as? Double) == 1.23)
    }
}
