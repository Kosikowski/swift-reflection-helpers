//
//  injectable.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

/// Minimal Dependency Injection container protocol.
protocol Container {
    func register(_ instance: Any)
}

/// Simple in-memory implementation for example/testing.
class SimpleContainer: Container {
    private var registrations: [Any] = []
    func register(_ instance: Any) {
        registrations.append(instance)
    }
}

protocol Injectable {
    init()
}

// Scan a module and register all types that conform to Injectable
// i.e. withXcode Buld Tool Plugin.
func autoWire(types: [Any.Type], into c: Container) {
    for type in types {
        // Check if type conforms to Injectable
        if let injectableType = type as? Injectable.Type {
            // Try to initialize using default initializer
            let instance = injectableType.init()
            c.register(instance)
        }
    }
}
