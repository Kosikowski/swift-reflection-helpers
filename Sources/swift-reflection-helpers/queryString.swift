//
//  queryString.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

/*
 Converts a struct or class instance into a URL query string by reflecting on its properties.
 Each property is mapped to a "key=value" pair, joined with &. Useful for encoding parameters for web requests.

 - Parameter params: Any value (typically a struct or class) whose properties will be converted.
 - Returns: A string in URL query format, e.g., "name=John&id=7".
 */
func queryString<T>(_ params: T) -> String {
    // Use Mirror to reflect on the properties of the input
    Mirror(reflecting: params)
        .children
        // For each child (property), extract its label and value
        .compactMap { child -> String? in
            guard let k = child.label else { return nil } // Skip properties without a label
            // Format as "key=value"
            return "\(k)=\(child.value)"
        }
        // Join all "key=value" pairs with an ampersand
        .joined(separator: "&")
}

/*
 // Example usage:
 struct UserQuery {
     let name: String
     let id: Int
 }
 let query = queryString(UserQuery(name: "Alice", id: 42))
 // query == "name=Alice&id=42"
 */
