//
//  log.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Foundation

enum FeedItem {}

func log(_ item: FeedItem) {
    let m = Mirror(reflecting: item)
    print("case:", String(describing: m.subjectType)) // FeedItem
    if let child = m.children.first { // only one payload
        print("label:", child.label ?? "(payload)")
        print("value:", child.value)
    }
}
