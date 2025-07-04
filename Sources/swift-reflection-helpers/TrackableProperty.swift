//
//  TrackableProperty.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

protocol TrackableField {}

@propertyWrapper struct TrackableProperty<Value>: TrackableField {
    var wrappedValue: Value
}

// usage
// struct SignUpData {
//    @TrackableProperty var email: String = ""
//    @TrackableProperty var password: String = ""
//    var rememberMe: Bool = false      // not a form field
// }
// returns ["email", "password"]

func gatherFieldsToTrack<T>(_ vm: T) -> [String] {
    Mirror(reflecting: vm).children.compactMap { child in
        guard child.value is TrackableField else { return nil }
        return child.label
    }
}
