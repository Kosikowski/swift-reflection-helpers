@testable import swift_reflection_helpers
import Testing

import Foundation

// Use the provided matches() function
// Simple struct for the tests
struct Dog {
    let name: String
    let age: Int
    let tags: [String]
}

@Suite("matches() deep reflection search")
struct MatchesTests {
    @Test("matches with string fields")
    func matchString() async throws {
        let p = Dog(name: "Alice Smith", age: 34, tags: ["engineer", "swift"])
        #expect(matches(p, query: "swift"))
        #expect(matches(p, query: "alice"))
        #expect(!matches(p, query: "35"))
    }

    @Test("matches with nested collections")
    func matchNested() async throws {
        let values: [Any] = [Dog(name: "Bob", age: 27, tags: ["dev"]), 42, "hello"]
        #expect(matches(values, query: "bob"))
        #expect(matches(values, query: "42"))
        #expect(matches(values, query: "dev"))
        #expect(matches(values, query: "hello"))
        #expect(!matches(values, query: "absent"))
    }

    @Test("matches is case insensitive")
    func matchCaseInsensitivity() async throws {
        let p = Dog(name: "Charlie", age: 50, tags: ["TeStCaSe"])
        #expect(matches(p, query: "testcase"))
        #expect(matches(p, query: "TESTCASE"))
    }
}
