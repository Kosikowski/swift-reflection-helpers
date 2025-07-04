//
//  KVCInitialisable.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

import Foundation

protocol KVCInitialisable {
    init(_ obj: AnyObject)
    init()
}

extension KVCInitialisable {
    init(_ obj: AnyObject) {
        self.init() // must provide a default init!
        let m = Mirror(reflecting: self)
        for child in m.children {
            if let key = child.label,
               let value = obj.value(forKey: key)
            {
                (self as AnyObject).setValue(value, forKey: key)
            }
        }
    }
}

// how to use:
// class ObjCUser: NSObject {
//  @objc var id = 0
//  @objc var name = ""
// }
//
// struct User: KVCInitialisable {
//  var id: Int = 0
//  var name: String = ""
// }
//
// let swiftUser = User(ObjCUser())
