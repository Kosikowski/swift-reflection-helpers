//
//  DictionaryConvertibleTests 2.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

@testable import swift_reflection_helpers
import Testing

@Suite("DictionaryConvertible tests")
struct DictionaryConvertibleTests {
    @Test("asDictionary provides correct values")
    func testAsDictionary() async throws {
        let person = Person()
        person.name = "Bob"
        person.age = 42
        let dict = person.asDictionary
        #expect(dict["name"] as? String == "Bob")
        #expect(dict["age"] as? Int == 42)
    }
}
