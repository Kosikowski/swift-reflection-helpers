//
//  Person.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//
import Foundation
@testable import swift_reflection_helpers
import Testing

class Person: NSObject, DefaultsStorable, DictionaryConvertible, KVCInitialisable {
    @objc dynamic var name: String
    @objc dynamic var age: Int

    override required init() {
        name = ""
        age = 0
        super.init()
    }

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    required convenience init(_ obj: AnyObject) {
        self.init()
        if let name = obj.value(forKey: "name") as? String {
            self.name = name
        }
        if let age = obj.value(forKey: "age") as? Int {
            self.age = age
        }
    }

    var asDictionary: [String: Any] {
        return [
            "name": name,
            "age": age,
        ]
    }
}
