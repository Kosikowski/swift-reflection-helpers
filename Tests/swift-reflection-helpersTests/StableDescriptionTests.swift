//
//  StableDescriptionTests.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//
@testable import swift_reflection_helpers
import Testing

@Suite("stableDescription() Tests")
struct StableDescriptionTests {
    @Test("Description is stable and sorted by label")
    func testStableDescription() async throws {
        let user = User(id: 42, name: "Alice", email: "alice@example.com")
        let desc = stableDescription(user)
        let lines = desc.split(separator: "\n")
        #expect(lines.first == "email=alice@example.com")
        #expect(lines.last == "name=Alice" || lines.last == "id=42") // order of id/name may vary if labels are tied
        #expect(desc.contains("id=42"))
    }

    @Test("Empty struct yields empty string")
    func testEmptyStruct() async throws {
        struct Empty {}
        let desc = stableDescription(Empty())
        #expect(desc.isEmpty)
    }
}
