//
//  toCSV.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

/// Returns (`headerLine`, `rows`)
func toCSV<T>(_ values: [T]) -> (String, [String]) {
    guard let first = values.first else { return ("", []) }
    let labels = Mirror(reflecting: first).children.compactMap(\.label)
    let header = labels.joined(separator: ",")

    func row(for value: T) -> String {
        Mirror(reflecting: value).children
            .map { "\($0.value)" }
            .joined(separator: ",")
    }

    return (header, values.map(row))
}
