@testable import swift_reflection_helpers
import Testing

struct Cat: DefaultInitializable {
    var name: String = ""
    var age: Int = 0
    public init() {}
}

struct Some: DefaultInitializable {
    public init() {}
}

//
// @Suite("propertyNames() function tests")
// struct PropertyNamesTests {
//    @Test("Returns property names and default values")
//    func testBasicProperties() async throws {
//        let props = propertyNames(Cat.self)
//        #expect(props.keys.contains("name"))
//        #expect(props.keys.contains("age"))
//        #expect(props["name"] as? String == "")
//        #expect(props["age"] as? Int == 0)
//    }
//
//    @Test("Empty struct returns empty dictionary")
//    func testEmptyStruct() async throws {
//        let props = propertyNames(Some.self)
//        #expect(props.isEmpty)
//    }
// }
