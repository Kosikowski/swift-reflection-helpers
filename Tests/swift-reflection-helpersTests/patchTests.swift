@testable import swift_reflection_helpers
import Testing

@Suite("patch() function tests")
struct PatchFunctionTests {
    struct User {
        var name: String
        var age: Int
        var email: String
    }

    @Test("Detects changed properties")
    func testChangedProperties() async throws {
        let oldUser = User(name: "Alice", age: 30, email: "alice@mail.com")
        let newUser = User(name: "Alice", age: 31, email: "alice@work.com")
        let diffs = patch(oldUser, newUser)
        #expect(diffs.count == 2)
        #expect(diffs.contains { $0.0 == "age" && ("\($0.1)" == "31") })
        #expect(diffs.contains { $0.0 == "email" && ("\($0.1)" == "alice@work.com") })
    }

    @Test("Returns empty for no differences")
    func testNoDifferences() async throws {
        let u = User(name: "Bob", age: 44, email: "b@c.com")
        let diffs = patch(u, u)
        #expect(diffs.isEmpty)
    }

    @Test("Handles different order of changes")
    func testAllPropertiesChanged() async throws {
        let old = User(name: "A", age: 1, email: "a@a.com")
        let new = User(name: "B", age: 2, email: "b@b.com")
        let diffs = patch(old, new)
        #expect(diffs.count == 3)
    }
}
