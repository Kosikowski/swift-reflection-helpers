//
//  ToDotDictTests.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//
@testable import swift_reflection_helpers
import Testing

@Suite("toDotDict() Tests")
struct ToDotDictTests {
    @Test("Flattens simple struct")
    func testFlat() async throws {
        let address = Address(city: "Paris", zip: 12345)
        let dict = toDotDict(address)
        #expect(dict["city"] as? String == "Paris")
        #expect(dict["zip"] as? Int == 12345)
    }

    @Test("Flattens nested struct with dot keys")
    func testNested() async throws {
        let customer = Customer(name: "Jane", address: Address(city: "Paris", zip: 12345))
        let dict = toDotDict(customer)
        #expect(dict["name"] as? String == "Jane")
        #expect(dict["address.city"] as? String == "Paris")
        #expect(dict["address.zip"] as? Int == 12345)
    }

    @Test("Scalar value becomes top-level key")
    func testScalar() async throws {
        let dict = toDotDict(42, prefix: "value")
        #expect(dict.count == 1)
        #expect(dict["value"] as? Int == 42)
    }
}
