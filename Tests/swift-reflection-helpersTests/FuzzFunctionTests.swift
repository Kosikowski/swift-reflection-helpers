import Foundation
@testable import swift_reflection_helpers
import Testing

@Suite("fuzz(_:) randomizes supported class fields")
struct FuzzFunctionTests {
    class Example: NSObject {
        @objc dynamic var intField: Int = 1
        @objc dynamic var dblField: Double = 3.14
        @objc dynamic var boolField: Bool = false
        @objc dynamic var strField: String = "abc"
    }

    @Test("Randomizes Int/Double/Bool/String fields")
    func testRandomizesFields() async throws {
        // Create two identical instances
        let orig = Example()
        orig.intField = 100
        orig.dblField = 2.5
        orig.boolField = false
        orig.strField = "seed"
        let fuzzed = Example()
        fuzzed.intField = orig.intField
        fuzzed.dblField = orig.dblField
        fuzzed.boolField = orig.boolField
        fuzzed.strField = orig.strField
        // Fuzz only the second instance
        _ = fuzz(fuzzed)
        // Each run should have at least one field changed compared to the original
        let diffCount = [
            orig.intField != fuzzed.intField,
            orig.dblField != fuzzed.dblField,
            orig.boolField != fuzzed.boolField,
            orig.strField != fuzzed.strField,
        ].filter { $0 }.count
        #expect(diffCount > 0)
    }

    class NotSupported {}
    @Test("Leaves unsupported types unchanged")
    func testUnsupportedType() async throws {
        let orig = NotSupported()
        let fuzzed = fuzz(orig)
        #expect(type(of: fuzzed) == NotSupported.self)
    }
}
