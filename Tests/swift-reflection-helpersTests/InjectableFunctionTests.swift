@testable import swift_reflection_helpers
import Testing

@Suite("autoWire(_:,into:) registers Injectable types")
struct InjectableFunctionTests {
    @MainActor
    struct Service: @MainActor Injectable {
        @MainActor static var count = 0
        @MainActor init() { Service.count += 1 }
    }

    struct NotInjectable {}
    class TestContainer: Container {
        var registrations: [Any] = []
        func register(_ instance: Any) { registrations.append(instance) }
    }

    @Test("Registers only Injectable types")
    func testRegistersInjectableTypes() async throws {
        let container = TestContainer()
        await MainActor.run { Service.count = 0 }
        autoWire(types: [Service.self, NotInjectable.self], into: container)
        #expect(container.registrations.count == 1)
        #expect(container.registrations.first is Service)
        let count = await MainActor.run { Service.count }
        #expect(count == 1)
    }

    @Test("Handles empty type list")
    func testEmptyTypes() async throws {
        let container = TestContainer()
        autoWire(types: [], into: container)
        #expect(container.registrations.isEmpty)
    }
}
