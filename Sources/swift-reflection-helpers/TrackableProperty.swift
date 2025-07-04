//
//  TrackableProperty.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

/// Protocol to mark types as trackable fields for reflective discovery.
protocol TrackableField {}

/// Property wrapper used to mark properties for tracking.
/// Usage: Attach to form fields or other properties you wish to enumerate with reflection.
@propertyWrapper struct TrackableProperty<Value>: TrackableField {
    var wrappedValue: Value
}

/*
// Example use case:

// Define a data structure with some fields marked as @TrackableProperty
struct SignUpData {
    @TrackableProperty var email: String = ""
    @TrackableProperty var password: String = ""
    var rememberMe: Bool = false // not a form field, not tracked
}

let formData = SignUpData()
let trackedFields = gatherFieldsToTrack(formData)
print(trackedFields) // Output: ["email", "password"]
*/

/// Gathers the property names of all fields marked as TrackableProperty in a given instance.
/// Uses Swift reflection to enumerate properties conforming to TrackableField.
func gatherFieldsToTrack<T>(_ vm: T) -> [String] {
    Mirror(reflecting: vm).children.compactMap { child in
        // Only include children whose value is a TrackableField
        guard child.value is TrackableField else { return nil }
        // Return the property's label (name)
        return child.label
    }
}
