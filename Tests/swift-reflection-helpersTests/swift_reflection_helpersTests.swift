@testable import swift_reflection_helpers
import Testing

struct TestStruct { var a: Int; var b: String }
class TestClass { var x: Double = 1.5; var y: String = "hi" }
enum TestEnum { case foo, bar(Int) }

@Suite("Reflection helpers")
struct ReflectionHelpersTests {
    @Test func testTypeName() async throws {
        #expect(typeName(of: 42) == "Int")
    }

    @Test func testMirrorOf() async throws {
        let m = mirror(of: "hi")
        #expect(m.subjectType == String.self)
    }

    @Test func testChildrenOf() async throws {
        let s = TestStruct(a: 5, b: "q")
        let c = children(of: s)
        #expect(c.count == 2)
        #expect(c[0].label == "a")
        #expect(c[0].value as? Int == 5)
        #expect(c[1].label == "b")
    }

    @Test func testPropertyLabels() async throws {
        let s = TestStruct(a: 1, b: "b")
        #expect(propertyLabels(of: s) == ["a", "b"])
    }

    @Test func testPropertyValues() async throws {
        let s = TestStruct(a: 9, b: "t")
        #expect(propertyValues(of: s).count == 2)
    }

    @Test func testIsClass() async throws {
        #expect(isClass(TestClass()))
        #expect(!isClass(TestStruct(a: 0, b: "")))
    }

    @Test func testIsStruct() async throws {
        #expect(isStruct(TestStruct(a: 1, b: "")))
        #expect(!isStruct(TestClass()))
    }

    @Test func testIsEnum() async throws {
        #expect(isEnum(TestEnum.foo))
        #expect(!isEnum(TestStruct(a: 1, b: "")))
    }

    @Test func testIsOptional() async throws {
        let v: Int? = 5
        #expect(isOptional(v))
        #expect(!isOptional(5))
    }

    @Test func testUnwrapOptional() async throws {
        let v: Int? = 7
        let (exists, val) = unwrapOptional(v)
        #expect(exists)
        #expect((val as? Int) == 7)
        let v2: Int? = nil
        let (exists2, val2) = unwrapOptional(v2)
        #expect(!exists2)
        #expect(val2 == nil)
    }

    @Test func testPropertyCount() async throws {
        let s = TestStruct(a: 1, b: "s")
        #expect(propertyCount(of: s) == 2)
    }

    @Test func testPropertyType() async throws {
        let s = TestStruct(a: 5, b: "t")
        #expect(propertyType(ofLabel: "a", in: s) == Int.self)
        #expect(propertyType(ofLabel: "b", in: s) == String.self)
        #expect(propertyType(ofLabel: "z", in: s) == nil)
    }

    @Test func testPropertyValueOfLabel() async throws {
        let s = TestStruct(a: 5, b: "t")
        #expect((propertyValue(ofLabel: "a", in: s) as? Int) == 5)
        #expect(propertyValue(ofLabel: "z", in: s) == nil)
    }

    @Test func testMirrorAncestry() async throws {
        let t = TestClass()
        let ancestry = mirrorAncestry(of: t)
        #expect(!ancestry.isEmpty)
        #expect(ancestry[0].subjectType == TestClass.self)
    }

    @Test func testAllPropertyLabelsInHierarchy() async throws {
        let o = TestClass()
        let labs = allPropertyLabelsInHierarchy(of: o)
        #expect(labs.contains("x"))
    }

    @Test func testAllPropertyValuesInHierarchy() async throws {
        let o = TestClass()
        let vals = allPropertyValuesInHierarchy(of: o)
        #expect(vals.contains(where: { ($0 as? Double) == 1.5 }))
    }

    @Test func testAllChildrenInHierarchy() async throws {
        let o = TestClass()
        let c = allChildrenInHierarchy(of: o)
        #expect(c.contains(where: { $0.label == "x" }))
    }

    @Test func testSuperclassName() async throws {
        class Sub: TestClass {}
        let s = Sub()
        #expect(superclassName(of: s) == "TestClass")
    }

    @Test func testSubjectTypeName() async throws {
        let v = TestClass()
        #expect(subjectTypeName(of: v).contains("TestClass"))
    }

    @Test func testConformsToProtocol() async throws {
        protocol P {}
        struct Q: P {}
        let q = Q()
        #expect(conformsToProtocol(q, protocolType: P.self))
        #expect(!conformsToProtocol(TestStruct(a: 1, b: ""), protocolType: P.self))
    }

    @Test func testIsTuple() async throws {
        let tup = (1, 2, 3)
        #expect(isTuple(tup))
        #expect(!isTuple(TestStruct(a: 1, b: "")))
    }

    @Test func testTupleElements() async throws {
        let tup = (a: 5, b: "q")
        let elems = tupleElements(of: tup)
        #expect(elems?.count == 2)
        #expect(elems?[0].label == "a")
    }

    @Test func testAsDictionary() async throws {
        let s = TestStruct(a: 4, b: "f")
        let d = asDictionary(s)
        #expect(d?["a"] as? Int == 4)
        #expect(d?["b"] as? String == "f")
    }

    @Test func testPropertyValueAtIndex() async throws {
        let s = TestStruct(a: 10, b: "g")
        #expect((propertyValue(at: 1, of: s) as? String) == "g")
        #expect(propertyValue(at: 3, of: s) == nil)
    }

    @Test func testPropertyLabelAtIndex() async throws {
        let s = TestStruct(a: 10, b: "g")
        #expect(propertyLabel(at: 0, of: s) == "a")
        #expect(propertyLabel(at: 2, of: s) == nil)
    }
}
