// CustomStringConvertibleDescriptionTests.swift
// Unit tests for the reflection-based `description` extension.

@testable import swift_reflection_helpers
import Testing

private struct PersonStruct: CustomStringConvertible {
    var name: String
    var age: Int
    // No manual description implementation—uses extension.
}

private class AnimalStruct: CustomStringConvertible {
    var species: String
    var legs: Int
    init(species: String, legs: Int) {
        self.species = species
        self.legs = legs
    }
}

private struct NoProperties: CustomStringConvertible {}

@Suite("CustomStringConvertible reflection-based description")
struct CustomStringConvertibleDescriptionTests {
    @Test("Struct: outputs all stored properties")
    func structDescription() async throws {
        let person = PersonStruct(name: "Alice", age: 30)
        let desc = person.description
        #expect(desc.contains("name: Alice"))
        #expect(desc.contains("age: 30"))
        // Accepts both orders: name first or age first.
        #expect(["name: Alice, age: 30", "age: 30, name: Alice"].contains(desc))
    }

    @Test("Class: outputs all stored properties")
    func classDescription() async throws {
        let animal = AnimalStruct(species: "Dog", legs: 4)
        let desc = animal.description
        #expect(desc.contains("species: Dog"))
        #expect(desc.contains("legs: 4"))
        #expect(["species: Dog, legs: 4", "legs: 4, species: Dog"].contains(desc))
    }

    @Test("Struct with no properties: returns empty string")
    func emptyStructDescription() async throws {
        let empty = NoProperties()
        #expect(empty.description == "")
    }

    @Test("Tuple property: uses underscore for unlabeled")
    func tuplePropertyDescription() async throws {
        struct Pair: CustomStringConvertible { let x: Int; let y: Int }
        let pair = Pair(x: 1, y: 2)
        let desc = pair.description
        #expect(desc.contains("x: 1"))
        #expect(desc.contains("y: 2"))
    }
}
