//
//  column.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

protocol DefaultInitializable {
    init()
}

func columns<T: DefaultInitializable>(_ type: T.Type) -> String {
    Mirror(reflecting: type.init()).children
        .compactMap(\.label)
        .joined(separator: ", ")
}
