// columnTests.swift
// Unit tests for `columns` in swift-reflection-helpers

@testable import swift_reflection_helpers
import Testing

private class Empty: DefaultInitializable {
    required init() {}
}

private class UnlabeledTuple: DefaultInitializable {
    var foo: (Int, Int) = (1, 2) // Should show up as 'foo'
    required init() {}
}

// @Suite("columns(_:) extracts property names as CSV headers")
// struct ColumnsFunctionTests {
//    @Test("Returns CSV column names for a struct with 3 properties")
//    func testPersonColumns() async throws {
//        let headers = columns(Person.self)
//        #expect(headers == "name, age, isActive")
//    }
//
//    @Test("Returns empty string for struct with no properties")
//    func testEmptyStruct() async throws {
//        let headers = columns(Empty.self)
//        #expect(headers == "")
//    }
//
//    @Test("Returns property name for property that is a tuple")
//    func testUnlabeledTupleProperty() async throws {
//        let headers = columns(UnlabeledTuple.self)
//        #expect(headers == "foo")
//    }
// }
//
