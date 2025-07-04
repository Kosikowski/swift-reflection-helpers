@testable import swift_reflection_helpers
import Testing

@Suite("reflectiveEquals() function tests")
struct ReflectiveEqualsTests {
    struct Point { let x: Int; let y: Int }
    struct Wrapper { let value: Int }
    struct Person { let name: String; let age: Int }

    @Test("Identical struct instances are equal")
    func testIdenticalStructs() async throws {
        let a = Point(x: 5, y: 10)
        let b = Point(x: 5, y: 10)
        #expect(reflectiveEquals(a, b))
    }

    @Test("Different values are not equal")
    func testDifferentValues() async throws {
        let a = Wrapper(value: 5)
        let b = Wrapper(value: 99)
        #expect(!reflectiveEquals(a, b))
    }

    @Test("Structs with all properties different")
    func testAllPropertiesDifferent() async throws {
        let a = Person(name: "A", age: 1)
        let b = Person(name: "B", age: 2)
        #expect(!reflectiveEquals(a, b))
    }

    @Test("Handles empty structs")
    func testEmptyStructs() async throws {
        struct Empty {}
        #expect(reflectiveEquals(Empty(), Empty()))
    }
}
