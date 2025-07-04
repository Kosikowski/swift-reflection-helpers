@testable import swift_reflection_helpers
import Testing

@Suite("queryString() function tests")
struct QueryStringTests {
    struct UserQuery {
        let name: String
        let id: Int
    }

    struct MixedTypes {
        let a: Int
        let b: String
        let c: Bool
    }

    @Test("Basic conversion to query string")
    func testBasicConversion() async throws {
        let query = queryString(UserQuery(name: "Alice", id: 42))
        #expect(query.contains("name=Alice"))
        #expect(query.contains("id=42"))
        #expect(query.contains("&"))
    }

    @Test("Handles multiple types")
    func testMultipleTypes() async throws {
        let query = queryString(MixedTypes(a: 3, b: "xyz", c: true))
        #expect(query.contains("a=3"))
        #expect(query.contains("b=xyz"))
        #expect(query.contains("c=true"))
    }

    @Test("Handles empty struct")
    func testEmptyStruct() async throws {
        struct Empty {}
        let query = queryString(Empty())
        #expect(query.isEmpty)
    }
}
