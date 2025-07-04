//
//  toCSV.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

/// Converts an array of value types to a CSV header and rows using Swift reflection.
///
/// - Parameter values: An array of values to be converted to CSV format.
/// - Returns: A tuple containing the header line and an array of row strings.
func toCSV<T>(_ values: [T]) -> (String, [String]) {
    // Handle the empty case: return empty header and rows
    guard let first = values.first else { return ("", []) }
    // Use reflection to extract field names from the first element for the header
    let labels = Mirror(reflecting: first).children.compactMap(\.label)
    let header = labels.joined(separator: ",")

    // Helper function to map a value to a CSV row
    func row(for value: T) -> String {
        Mirror(reflecting: value).children
            .map { "\($0.value)" }
            .joined(separator: ",")
    }

    // Build CSV rows for all values
    return (header, values.map(row))
}

/*
 // Example usage:
 struct Person {
     let name: String
     let age: Int
 }

 let people = [
     Person(name: "Alice", age: 30),
     Person(name: "Bob", age: 25)
 ]

 let (header, rows) = toCSV(people)
 print(header) // Output: "name,age"
 for row in rows {
     print(row) // Output: "Alice,30" and "Bob,25"
 }
 */
