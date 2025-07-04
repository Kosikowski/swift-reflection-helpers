//
//  sortBy.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//
import Foundation

//func sortBy<T>(_ key: String, array: inout [T]) {
//    array.sort {
//        guard
//            let l = value(of: $0, whereName: { $0 == key }) as? Comparable,
//            let r = value(of: $1, whereName: { $0 == key }) as? Comparable
//        else { return false }
//        return l < r
//    }
//}
//
//extension Array {
//    /// Sorts the array in place by a property name using reflection.
//    /// - Parameter key: The name of the property to sort by.
//    mutating func sortBy(_ key: String) {
//        sort {
//            guard
//                let l = Mirror(reflecting: $0).children.first(where: { $0.label == key })?.value as? Comparable,
//                let r = Mirror(reflecting: $1).children.first(where: { $0.label == key })?.value as? Comparable
//            else {
//                return false
//            }
//            return l < r
//        }
//    }
//}
