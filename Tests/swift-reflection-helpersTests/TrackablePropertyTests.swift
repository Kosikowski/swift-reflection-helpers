@testable import swift_reflection_helpers
import Testing

@Suite("TrackableProperty: reflection and collection")
struct TrackablePropertyTests {
    private struct FormData {
        @TrackableProperty var email: String = "test@example.com"
        @TrackableProperty var password: String = "secret"
        var rememberMe: Bool = true // not marked as tracked
    }

    @Test("Only properties marked @TrackableProperty are gathered")
    func testGatherFields() async throws {
        let form = FormData()
        let fieldNames = gatherFieldsToTrack(form)
        #expect(fieldNames.sorted() == ["email", "password"])
    }

    @Test("Empty struct returns empty array")
    func testEmptyStruct() async throws {
        struct Empty {}
        let fields = gatherFieldsToTrack(Empty())
        #expect(fields.isEmpty)
    }

    @Test("Non-Trackable fields are ignored")
    func testNonTrackableIgnored() async throws {
        struct Mixed {
            @TrackableProperty var foo: Int = 42
            var bar: String = "not tracked"
        }
        let names = gatherFieldsToTrack(Mixed())
        #expect(names == ["foo"])
    }
}
