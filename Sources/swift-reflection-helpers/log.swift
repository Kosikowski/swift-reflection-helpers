//
//  log.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Foundation

protocol Loggable {}

// how to use
enum FeedItem: Loggable {
    case text(String)
        case image(url: URL, caption: String?)
        case ad(id: UUID)
}

func log(_ item: Loggable) {
    let m = Mirror(reflecting: item)
    print("case:", String(describing: m.subjectType)) // FeedItem
    if let child = m.children.first { // only one payload
        print("label:", child.label ?? "(payload)")
        print("value:", child.value)
    }
}
