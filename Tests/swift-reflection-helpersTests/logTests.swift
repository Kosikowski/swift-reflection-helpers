@testable import swift_reflection_helpers
import Testing

import Foundation

// We mirror the FeedItem example from log.swift
private enum FeedItem: Loggable {
    case text(String)
    case image(url: URL, caption: String?)
    case ad(id: UUID)
}

@Suite("Loggable utilities tests")
struct LogTests {
    @Test("Mirror: FeedItem.text case reflection")
    func testFeedItemTextReflection() async throws {
        let item = FeedItem.text("lorem")
        let m = Mirror(reflecting: item)
        #expect(String(describing: m.subjectType) == "FeedItem")
        let child = try #require(m.children.first)
        #expect(child.label == "text")
        #expect((child.value as? String) == "lorem")
    }

    @Test("Mirror: FeedItem.image case reflection")
    func testFeedItemImageReflection() async throws {
        let url = URL(string: "https://img")!
        let item = FeedItem.image(url: url, caption: "desc")
        let m = Mirror(reflecting: item)
        #expect(String(describing: m.subjectType) == "FeedItem")
        let child = try #require(m.children.first)
        // for enums with named payloads, label is case name
        #expect(child.label == "image")
        if let tuple = child.value as? (url: URL, caption: String?) {
            #expect(tuple.url == url)
            #expect(tuple.caption == "desc")
        }
    }
}
