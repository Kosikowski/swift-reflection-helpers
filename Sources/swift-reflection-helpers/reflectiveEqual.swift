//
//  reflectiveEqual.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

func reflectiveEquals(_ lhs: Any, _ rhs: Any) -> Bool {
    let ml = Mirror(reflecting: lhs)
    let mr = Mirror(reflecting: rhs)
    guard ml.children.count == mr.children.count else { return false }
    return zip(ml.children, mr.children).allSatisfy { "\($0.value)" == "\($1.value)" }
}
