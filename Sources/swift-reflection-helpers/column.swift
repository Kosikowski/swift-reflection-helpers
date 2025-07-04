//
//  column.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//
//  This file provides utilities for extracting the property names of a given type as a 
//  comma-separated string, suitable for use as CSV column headers or for other reflection-based 
//  scenarios. It leverages Swift's Mirror API to reflect over the properties of a value 
//  instantiated via its default initializer. This approach is useful when you need to generate 
//  header rows dynamically without manually specifying property names.
//
//  Usage scenarios include:
//  - Automatically generating CSV headers from data model types.
//  - Debugging or introspection tools that require property name lists.
//  
//  Limitations:
//  - The type must conform to DefaultInitializable to allow creation of a default instance.
//  - Only properties visible to Mirror and accessible via default init are included.
//  - Does not handle nested or computed properties specifically.

/// A protocol that requires conforming types to provide a default initializer.
/// This is necessary to create an instance of the type for reflection purposes,
/// enabling extraction of property names without knowing the type's internals.
protocol DefaultInitializable {
    init()
}

/// Returns a comma-separated string containing the names of the properties of the given type `T`.
///
/// - Parameter type: The type conforming to `DefaultInitializable` whose property names are to be extracted.
/// - Returns: A `String` with property names joined by ", ", suitable for use as CSV headers or similar.
///
/// This function creates a default instance of `T` using its parameterless initializer, reflects on 
/// its properties using `Mirror`, extracts the property labels, and joins them into a CSV-like header string.
/// It is intended for types where a default instance is meaningful and accessible.
/// 
/// Note: Only properties with labels are included; unlabeled tuple elements or similar will be ignored.
func columns<T: DefaultInitializable>(_ type: T.Type) -> String {
    // Create a default instance of the type to reflect on
    let instance = type.init()
    // Reflect on the instance to access its properties
    let mirror = Mirror(reflecting: instance)
    // Extract the labels (property names) of the children, ignoring any without labels
    let propertyNames = mirror.children.compactMap(\.label)
    // Join the property names into a single comma-separated string
    return propertyNames.joined(separator: ", ")
}
