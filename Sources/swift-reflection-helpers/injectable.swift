//
//  injectable.swift
//  swift-reflection-helpers
//
//  Created by Mateusz Kosikowski on 04/07/2025.
//

/// Minimal Dependency Injection container protocol.
/// Adopted by types that can register instances for dependency injection.
protocol Container {
    /// Registers an instance in the container.
    func register(_ instance: Any)
}

/// Simple in-memory implementation for example/testing purposes.
class SimpleContainer: Container {
    // Stores all registered instances.
    private var registrations: [Any] = []
    /// Registers an instance by appending to the registrations array.
    func register(_ instance: Any) {
        registrations.append(instance)
    }
}

/// Protocol for types that can be created and injected via the DI system.
protocol Injectable {
    /// Required default initializer so types can be instantiated automatically.
    init()
}

/**
 Scans an array of types and registers all that conform to Injectable into the provided container.

 - Parameters:
    - types: An array of types to scan.
    - c: The container to register found instances into.

 This is typically used for automatic wiring with Xcode Build Tool Plugins or similar tooling.
*/
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

//---
// Example Usage:
//
// /// Example service conforming to Injectable
// struct MyService: Injectable {
//     init() { print("MyService initialized") }
// }
//
// // Create the container
// let container = SimpleContainer()
//
// // Auto-wire all types conforming to Injectable
// autoWire(types: [MyService.self], into: container)
//
// // At this point, the container has an instance of MyService registered.
//---
