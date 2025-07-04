//
//  KVCInitialisable.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Foundation

// MARK: - KVCInitialisable

// This protocol enables easy conversion between Objective-C objects (using Key-Value Coding)
// and Swift structs/classes with matching property names. Useful for bridging legacy Objective-C models.

/// A protocol for types that can be initialised from an Objective-C object using KVC (Key-Value Coding).
/// Types must provide a default `init()` in addition to an initializer that takes an `AnyObject`.
protocol KVCInitialisable {
    /// Initializes a new instance by copying values from an Objective-C object via KVC.
    init(_ obj: AnyObject)
    /// Default initializer. All conforming types must be initializable without arguments.
    init()
}

extension KVCInitialisable {
    /// Initializes a new instance, copying property values from the given `AnyObject` using KVC.
    /// Assumes property names match between the Swift type and the Objective-C object.
    init(_ obj: AnyObject) {
        self.init() // must provide a default init!
        // Reflect on self to enumerate all properties.
        let m = Mirror(reflecting: self)
        for child in m.children {
            if let key = child.label,
               let value = obj.value(forKey: key) // use KVC to fetch value if key exists in obj
            {
                // Set the value on self using KVC. Requires that self is a class or bridged to NSObject.
                (self as AnyObject).setValue(value, forKey: key)
            }
        }
    }
}

// MARK: - Usage Example

// Suppose you have an Objective-C style class (NSObject-based):
//
// class ObjCUser: NSObject {
//   @objc var id = 0
//   @objc var name = ""
// }
//
// And a Swift struct conforming to KVCInitialisable:
//
// struct User: KVCInitialisable {
//   var id: Int = 0
//   var name: String = ""
// }
//
// You can create a Swift User from an Objective-C ObjCUser instance:
// let objcUser = ObjCUser()
// objcUser.id = 42
// objcUser.name = "Alice"
// let swiftUser = User(objcUser)
// // swiftUser.id == 42, swiftUser.name == "Alice"
//
// This enables type-safe bridging between Objective-C models and Swift value types with minimal code.
