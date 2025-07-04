//
//  MirrorHelperMethods.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 01/07/2025.
//

/**
 Reflection Helper Functions for Swift
 */

import Foundation

/// Returns the type name of a value as a `String`.
///
/// - Parameter value: The value whose type name is desired.
/// - Returns: A string representing the type name of the given value.
/// - Note: This is equivalent to `String(describing: type(of: value))`.
public func typeName(of value: Any) -> String {
    String(describing: type(of: value))
}

/// Returns a `Mirror` instance for a given value.
///
/// - Parameter value: The value to reflect.
/// - Returns: A `Mirror` reflecting the provided value.
/// - Note: `Mirror` provides runtime introspection of the value's structure.
public func mirror(of value: Any) -> Mirror {
    Mirror(reflecting: value)
}

/// Returns all children (property label-value pairs) as an array from a value.
///
/// - Parameter value: The value to extract children from.
/// - Returns: An array of tuples, each containing an optional label and the associated value.
/// - Note: Children correspond to stored properties for structs/classes and associated values for enums.
public func children(of value: Any) -> [(label: String?, value: Any)] {
    Array(Mirror(reflecting: value).children)
}

/// Returns all property labels for an instance.
///
/// - Parameter value: The value whose property labels are desired.
/// - Returns: An array of strings containing all non-nil property labels.
/// - Note: Only labels that are not `nil` are included; computed properties are not reflected.
public func propertyLabels(of value: Any) -> [String] {
    Mirror(reflecting: value).children.compactMap { $0.label }
}

/// Returns all property values for an instance.
///
/// - Parameter value: The value whose property values are desired.
/// - Returns: An array of values for each child property.
/// - Note: Order corresponds to the order of properties in the type definition.
public func propertyValues(of value: Any) -> [Any] {
    Mirror(reflecting: value).children.map { $0.value }
}

/// Checks if a value is a class instance.
///
/// - Parameter value: The value to check.
/// - Returns: `true` if the value is a class instance, `false` otherwise.
public func isClass(_ value: Any) -> Bool {
    Mirror(reflecting: value).displayStyle == .class
}

/// Checks if a value is a struct instance.
///
/// - Parameter value: The value to check.
/// - Returns: `true` if the value is a struct instance, `false` otherwise.
public func isStruct(_ value: Any) -> Bool {
    Mirror(reflecting: value).displayStyle == .struct
}

/// Checks if a value is an enum instance.
///
/// - Parameter value: The value to check.
/// - Returns: `true` if the value is an enum instance, `false` otherwise.
public func isEnum(_ value: Any) -> Bool {
    Mirror(reflecting: value).displayStyle == .enum
}

/// Checks if a value is an optional.
///
/// - Parameter value: The value to check.
/// - Returns: `true` if the value is an Optional type, `false` otherwise.
public func isOptional(_ value: Any) -> Bool {
    Mirror(reflecting: value).displayStyle == .optional
}

/// Unwraps an optional value.
///
/// - Parameter value: The optional value to unwrap.
/// - Returns: A tuple where:
///   - `exists`: `true` if the optional contains a value or the input was not optional,
///   - `value`: the unwrapped value if present, or `nil` if the optional is `nil`.
///
/// - Note: If the input value is not an optional, it's returned as-is with `exists == true`.
/// This function does not perform deep unwrapping of nested optionals.
public func unwrapOptional(_ value: Any) -> (exists: Bool, value: Any?) {
    let mirror = Mirror(reflecting: value)
    guard mirror.displayStyle == .optional else { return (true, value) }
    if let child = mirror.children.first {
        // Non-nil optional
        return (true, child.value)
    }
    // nil optional
    return (false, nil)
}

/// Returns the count of properties/children of a value.
///
/// - Parameter value: The value to inspect.
/// - Returns: The number of children (properties/associated values) the value has.
public func propertyCount(of value: Any) -> Int {
    Mirror(reflecting: value).children.count
}

/// Returns the type of a named property (by label), or nil if not found.
///
/// - Parameters:
///   - label: The property label to look for.
///   - value: The instance containing the property.
/// - Returns: The type of the property if found, otherwise `nil`.
/// - Note: This searches only immediate children; does not traverse inheritance hierarchy.
public func propertyType<T>(ofLabel label: String, in value: T) -> Any.Type? {
    if let v = Mirror(reflecting: value).children.first(where: { $0.label == label })?.value {
        return type(of: v)
    }
    return nil
}

/// Gets a property value by label, if it exists.
///
/// - Parameters:
///   - label: The property label to look for.
///   - value: The instance containing the property.
/// - Returns: The value of the property if found, otherwise `nil`.
/// - Note: Only searches immediate children.
public func propertyValue<T>(ofLabel label: String, in value: T) -> Any? {
    Mirror(reflecting: value).children.first { $0.label == label }?.value
}

/// Collects all mirrors in the ancestry (superclass chain) of a value.
///
/// - Parameter value: The value to reflect.
/// - Returns: An array of `Mirror` objects starting from the instance mirror up through its superclass hierarchy.
/// - Note: Useful for inspecting inherited properties in class types.
public func mirrorAncestry(of value: Any) -> [Mirror] {
    var result: [Mirror] = []
    var current: Mirror? = Mirror(reflecting: value)
    while let m = current {
        result.append(m)
        current = m.superclassMirror
    }
    return result
}

/// Returns all property labels in the entire class hierarchy (for classes), with label deduplication.
///
/// - Parameter value: The class instance to inspect.
/// - Returns: An array of unique property labels from the entire inheritance chain in declaration order.
/// - Note: For non-class types, only immediate properties are returned.
public func allPropertyLabelsInHierarchy(of value: Any) -> [String] {
    var seen = Set<String>()
    var result: [String] = []
    for mirror in mirrorAncestry(of: value) {
        for label in mirror.children.compactMap({ $0.label }) {
            if seen.insert(label).inserted {
                result.append(label)
            }
        }
    }
    return result
}

/// Flattens all property values in the complete class hierarchy (for classes).
///
/// - Parameter value: The class instance to inspect.
/// - Returns: An array containing all property values from the entire inheritance chain.
/// - Note: For non-class types, only immediate children are returned.
public func allPropertyValuesInHierarchy(of value: Any) -> [Any] {
    mirrorAncestry(of: value).flatMap { $0.children.map { $0.value } }
}

/// Returns all (label, value) pairs (children) in full ancestry.
///
/// - Parameter value: The value to inspect.
/// - Returns: An array of tuples containing optional labels and corresponding values from the full inheritance chain.
/// - Note: For enums, structs, or other types, this will just return immediate children repeated if no superclass.
public func allChildrenInHierarchy(of value: Any) -> [(label: String?, value: Any)] {
    mirrorAncestry(of: value).flatMap { $0.children }
}

/// Returns the superclass type name as a `String`, if any; else `nil`.
///
/// - Parameter value: The value whose superclass name is desired.
/// - Returns: The name of the immediate superclass type as a string, or `nil` if none exists.
/// - Note: Only applicable for class types.
public func superclassName(of value: Any) -> String? {
    Mirror(reflecting: value).superclassMirror.map { String(describing: $0.subjectType) }
}

/// Returns the subject type as a `String` for a value.
///
/// - Parameter value: The value to inspect.
/// - Returns: The string representation of the subject type (the static type of the value).
public func subjectTypeName(of value: Any) -> String {
    String(describing: Mirror(reflecting: value).subjectType)
}

/// Checks if a type (given as value) conforms to a protocol (by metatype comparison).
/// Works only for concrete protocols.
///
/// - Parameters:
///   - value: The value to test.
///   - protocolType: The protocol type to check conformance against.
/// - Returns: `true` if the value conforms to the protocol, `false` otherwise.
/// - Note: This uses `as?` downcasting and thus requires a concrete protocol (non-existential).
public func conformsToProtocol<T>(_ value: Any, protocolType _: T.Type) -> Bool {
    (value as? T) != nil
}

/// Returns true if a value is a tuple.
///
/// - Parameter value: The value to check.
/// - Returns: `true` if the value is a tuple, `false` otherwise.
///
/// - Note: Tuples have a distinct `.tuple` display style in Mirrors.
public func isTuple(_ value: Any) -> Bool {
    Mirror(reflecting: value).displayStyle == .tuple
}

/// Returns all tuple elements as (label, value) pairs.
///
/// - Parameter value: The tuple value to inspect.
/// - Returns: An array of tuples each with optional label and value, or `nil` if the value is not a tuple.
///
/// - Note: Tuple element labels may be indices like `.0`, `.1`, or names if named tuples.
public func tupleElements(of value: Any) -> [(label: String?, value: Any)]? {
    let mirror = Mirror(reflecting: value)
    guard mirror.displayStyle == .tuple else { return nil }
    return Array(mirror.children)
}

/// Converts a value to `Dictionary<String, Any>` if possible (struct/class with string labels), else `nil`.
///
/// - Parameter value: The value to convert.
/// - Returns: A dictionary mapping property names to their values if all children have non-nil labels, otherwise `nil`.
///
/// - Note: Useful for quick dictionary representations of structs/classes with label-based properties.
/// If any child lacks a label, conversion fails returning `nil`.
public func asDictionary(_ value: Any) -> [String: Any]? {
    let children = Mirror(reflecting: value).children
    var result: [String: Any] = [:]
    for child in children {
        if let label = child.label {
            result[label] = child.value
        } else {
            // Child with nil label encountered, cannot build dictionary
            return nil
        }
    }
    return result
}

/// Returns the value of a property at a given index, if it exists.
///
/// - Parameters:
///   - index: The zero-based index of the property.
///   - value: The value to inspect.
/// - Returns: The property value at the given index, or `nil` if index is out of bounds.
///
/// - Note: Index order corresponds to the order of children as reflected by Mirror.
public func propertyValue(at index: Int, of value: Any) -> Any? {
    let children = Array(Mirror(reflecting: value).children)
    guard index >= 0, index < children.count else { return nil }
    return children[index].value
}

/// Returns the label of a property at a given index, if it exists.
///
/// - Parameters:
///   - index: The zero-based index of the property.
///   - value: The value to inspect.
/// - Returns: The property label at the given index, or `nil` if index is out of bounds or label is missing.
public func propertyLabel(at index: Int, of value: Any) -> String? {
    let children = Array(Mirror(reflecting: value).children)
    guard index >= 0, index < children.count else { return nil }
    return children[index].label
}
