//
//  reflectiveEqual.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

/// Compares two values by reflecting on their children using Swift's Mirror API.
/// - Parameters:
///   - lhs: The first value to compare.
///   - rhs: The second value to compare.
/// - Returns: True if both values have the same number of children and all children compare equal by their string values; otherwise, false.
/// - Note: This is a shallow, string-based comparison. It does not handle nested structures deeply or compare value types precisely.
func reflectiveEquals(_ lhs: Any, _ rhs: Any) -> Bool {
    // Create mirrors to introspect both values.
    let ml = Mirror(reflecting: lhs)
    let mr = Mirror(reflecting: rhs)
    // Ensure both mirrors have the same number of children (properties).
    guard ml.children.count == mr.children.count else { return false }
    // Compare each child value as a string.
    return zip(ml.children, mr.children).allSatisfy { "\($0.value)" == "\($1.value)" }
}

/*
 // Example usage:
 struct Point { let x: Int; let y: Int }
 let a = Point(x: 5, y: 10)
 let b = Point(x: 5, y: 10)
 let c = Point(x: 5, y: 11)

 reflectiveEquals(a, b) // true
 reflectiveEquals(a, c) // false
 */
