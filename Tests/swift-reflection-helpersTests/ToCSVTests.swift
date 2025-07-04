//
//  ToCSVTests.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

@testable import swift_reflection_helpers
import Testing

struct Animal {
    let kind: String
    let weight: Int
}

@Suite("toCSV() Tests")
struct ToCSVTests {
    @Test("Converts array to CSV header and rows")
    func testCSV() async throws {
        let animals = [Animal(kind: "Cat", weight: 4), Animal(kind: "Dog", weight: 8)]
        let (header, rows) = toCSV(animals)
        #expect(header == "kind,weight")
        #expect(rows[0] == "Cat,4")
        #expect(rows[1] == "Dog,8")
    }

    @Test("Empty array returns empty header and rows")
    func testEmpty() async throws {
        let empty: [Animal] = []
        let (header, rows) = toCSV(empty)
        #expect(header.isEmpty)
        #expect(rows.isEmpty)
    }
}
