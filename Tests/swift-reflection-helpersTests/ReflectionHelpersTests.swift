@testable import swift_reflection_helpers
import Testing

// MARK: - Tests for sortBy.swift

@Suite("sortBy() and Array.sortBy() Tests")
struct SortByTests {
    @Test("Sorts by age ascending with sortBy function")
    func testSortFunction() async throws {
        var people = [Person(name: "Bob", age: 25), Person(name: "Alice", age: 30), Person(name: "Chris", age: 22)]
        sortBy("age", array: &people)
        #expect(people.map { $0.name } == ["Chris", "Bob", "Alice"])
    }

    @Test("Sorts by name ascending with Array.sortBy")
    func testSortByExtension() async throws {
        var people = [Person(name: "Bob", age: 25), Person(name: "Alice", age: 30), Person(name: "Chris", age: 22)]
        people.sortBy("name")
        #expect(people.map { $0.name } == ["Alice", "Bob", "Chris"])
    }

    @Test("Keeps order if property not found")
    func testMissingProperty() async throws {
        var people = [Person(name: "A", age: 1), Person(name: "B", age: 2)]
        let original = people
        people.sortBy("notAProperty")
        #expect(people == original)
    }
}

// MARK: - Tests for toDotDict.swift
