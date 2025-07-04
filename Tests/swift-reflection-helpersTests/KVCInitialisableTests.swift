import Foundation
@testable import swift_reflection_helpers
import Testing

// Dummy class to test KVCInitialisable conformance
final class TestKVCInit: NSObject, KVCInitialisable {
    @objc dynamic var foo: String = ""
    @objc dynamic var bar: Int = 0

    override required init() {}
    required init(_ obj: AnyObject) {
        if let foo = obj.value(forKey: "foo") as? String {
            self.foo = foo
        }
        if let bar = obj.value(forKey: "bar") as? Int {
            self.bar = bar
        }
    }
}

@Suite("KVCInitialisable basic tests")
struct KVCInitialisableTests {
    @Test("init with AnyObject copies properties")
    func testInitWithObject() async throws {
        let obj = TestKVCInit()
        obj.setValue("hello", forKey: "foo")
        obj.setValue(42, forKey: "bar")
        let t = TestKVCInit(obj)
        #expect(t.foo == "hello")
        #expect(t.bar == 42)
    }

    @Test("default init")
    func testDefaultInit() async throws {
        let t = TestKVCInit()
        #expect(t.foo == "")
        #expect(t.bar == 0)
    }
}
