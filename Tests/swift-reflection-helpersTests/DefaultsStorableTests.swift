//
//  DefaultsStorableTests.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Foundation
@testable import swift_reflection_helpers
import Testing

@Suite("DefaultsStorable tests")
struct DefaultsStorableTests {
    @Test("Saving and loading Person to/from UserDefaults")
    func testSaveAndLoad() async throws {
        let defaults = UserDefaults.standard
        let keyName = "Person.name"
        let keyAge = "Person.age"

        // Clean up
        defaults.removeObject(forKey: keyName)
        defaults.removeObject(forKey: keyAge)

        var p = Person()
        p.name = "Alice"
        p.age = 25
        p.saveToDefaults()

        // Should be saved in UserDefaults
        #expect(defaults.string(forKey: keyName) == "Alice")
        #expect(defaults.integer(forKey: keyAge) == 25)

        // Load from defaults to a new object
        let loaded = Person.loadFromDefaults()
        #expect(loaded.name == "Alice")
        #expect(loaded.age == 25)
    }
}
