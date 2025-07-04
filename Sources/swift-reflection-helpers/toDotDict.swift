//
//  toDotCict.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

func toDotDict(_ any: Any, prefix: String = "") -> [String: Any] {
    var dict: [String: Any] = [:]
    let m = Mirror(reflecting: any)

    if m.children.isEmpty { // leaf
        dict[prefix] = any
    } else {
        for child in m.children {
            guard let label = child.label else { continue }
            let key = prefix.isEmpty ? label : "\(prefix).\(label)"
            dict.merge(toDotDict(child.value, prefix: key)) { $1 }
        }
    }
    return dict
}
