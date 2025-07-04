//
//  DictionaryConvertible.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

protocol DictionaryConvertible {}
extension DictionaryConvertible {
    var asDictionary: [String: Any] {
        Mirror(reflecting: self)
            .children.reduce(into: [:]) { dict, child in
                if let key = child.label { dict[key] = child.value }
            }
    }
}
