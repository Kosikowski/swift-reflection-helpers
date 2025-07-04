# Swift Reflection Helpers

A comprehensive Swift library that provides powerful reflection-based utilities for runtime introspection, serialization, debugging, and data manipulation. Built on top of Swift's `Mirror` API, this library offers a collection of protocols, extensions, and functions that make working with runtime reflection simple and efficient.

## Features

- **Runtime Property Inspection**: Extract property names, values, and types dynamically
- **Serialization & Persistence**: Convert objects to dictionaries, CSV, and UserDefaults storage
- **Deep Copying**: Create deep copies of objects using reflection
- **Tree Traversal**: Generic tree structure traversal with DFS and BFS
- **Dependency Injection**: Simple DI container with automatic wiring
- **Data Comparison**: Diff and patch functionality for object comparison
- **Query & Search**: Advanced search and filtering capabilities
- **Visualization**: Generate DOT graphs for tree structures

## Installation

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/your-username/swift-reflection-helpers.git", from: "1.0.0")
]
```

Or add it to your Xcode project via File → Add Package Dependencies.

## Core Protocols

### DefaultInitializable

Base protocol for types that can be instantiated with a default initializer. Required by many reflection utilities.

```swift
protocol DefaultInitializable {
    init()
}

struct Person: DefaultInitializable {
    var name: String = ""
    var age: Int = 0
    init() {}
}
```

### DictionaryConvertible

Convert any object to a dictionary representation using reflection.

```swift
protocol DictionaryConvertible {}

extension DictionaryConvertible {
    var asDictionary: [String: Any] {
        Mirror(reflecting: self)
            .children.reduce(into: [:]) { dict, child in
                if let key = child.label { dict[key] = child.value }
            }
    }
}

struct User: DictionaryConvertible {
    let name: String
    let age: Int
}

let user = User(name: "Alice", age: 30)
print(user.asDictionary) // ["name": "Alice", "age": 30]
```

### DeepCopying

Create deep copies of objects using reflection.

```swift
protocol DeepCopying: DefaultInitializable {}

extension DeepCopying {
    func deepCopy() -> Self {
        let copy = Self()
        for child in Mirror(reflecting: self).children {
            guard let name = child.label else { continue }
            let value = child.value
            let cloned: Any
            if let dc = value as? DeepCopying {
                cloned = dc.deepCopy()
            } else {
                cloned = value
            }
            (copy as AnyObject).setValue(cloned, forKey: name)
        }
        return copy
    }
}
```

### DefaultsStorable

Save and load objects to/from UserDefaults using reflection.

```swift
protocol DefaultsStorable: DefaultInitializable {}

extension DefaultsStorable {
    func saveToDefaults() {
        let defaults = UserDefaults.standard
        for child in Mirror(reflecting: self).children {
            guard let key = child.label else { continue }
            defaults.set(child.value, forKey: String(describing: Self.self) + "." + key)
        }
    }
    
    static func loadFromDefaults() -> Self {
        let obj = Self()
        let defaults = UserDefaults.standard
        for child in Mirror(reflecting: obj).children {
            guard let key = child.label else { continue }
            if let val = defaults.object(forKey: String(describing: Self.self) + "." + key) {
                (obj as AnyObject).setValue(val, forKey: key)
            }
        }
        return obj
    }
}
```

### TreeLike

Generic tree traversal with depth-first and breadth-first search.

```swift
protocol TreeLike {}

extension TreeLike {
    func flattenedDFS<T: TreeLike>() -> [T] {
        var out: [T] = []
        func walk(_ node: T) {
            out.append(node)
            for child in Mirror(reflecting: node).children {
                switch child.value {
                case let c as T: walk(c)
                case let arr as [T]: arr.forEach(walk)
                default: break
                }
            }
        }
        walk(self as! T)
        return out
    }
    
    func levels<T: TreeLike>() -> [[T]] {
        var result: [[T]] = []
        var queue: [T] = [self as! T]
        while !queue.isEmpty {
            result.append(queue)
            queue = queue.flatMap { node in
                Mirror(reflecting: node).children.compactMap {
                    switch $0.value {
                    case let c as T: return [c]
                    case let arr as [T]: return arr
                    default: return []
                    }
                }.flatMap { $0 }
            }
        }
        return result
    }
}
```

## Core Functions

### Property Inspection

```swift
// Get property names
let labels = propertyLabels(of: someObject)
let values = propertyValues(of: someObject)
let count = propertyCount(of: someObject)

// Get specific property
let value = propertyValue(ofLabel: "name", in: someObject)
let type = propertyType(ofLabel: "age", in: someObject)

// Type checking
let isClass = isClass(someObject)
let isStruct = isStruct(someObject)
let isEnum = isEnum(someObject)
let isOptional = isOptional(someValue)
```

### Serialization & Conversion

```swift
// Convert to CSV
let people = [Person(name: "Alice", age: 30), Person(name: "Bob", age: 25)]
let (header, rows) = toCSV(people)
// header: "name,age"
// rows: ["Alice,30", "Bob,25"]

// Convert to query string
struct UserQuery {
    let name: String
    let id: Int
}
let query = queryString(UserQuery(name: "Alice", id: 42))
// query: "name=Alice&id=42"

// Flatten nested objects
struct User {
    var name: String
    var address: Address
}
struct Address {
    var city: String
    var zip: Int
}
let user = User(name: "John", address: Address(city: "London", zip: 12345))
let flat = toDotDict(user)
// flat: ["name": "John", "address.city": "London", "address.zip": 12345]

// Stable description
let user = User(id: 42, name: "Alice", email: "alice@example.com")
print(stableDescription(user))
// Output (sorted by property name):
// email=alice@example.com
// id=42
// name=Alice
```

### Comparison & Diffing

```swift
// Reflective equality
let a = Point(x: 5, y: 10)
let b = Point(x: 5, y: 10)
let c = Point(x: 5, y: 11)

reflectiveEquals(a, b) // true
reflectiveEquals(a, c) // false

// Find differences
let oldUser = User(name: "Alice", age: 30, email: "alice@mail.com")
let newUser = User(name: "Alice", age: 31, email: "alice@work.com")

let changes = diff(oldUser, newUser)
// changes: ["age": 31, "email": "alice@work.com"]

let patches = patch(oldUser, newUser)
// patches: [("age", 31), ("email", "alice@work.com")]
```

### Search & Filtering

```swift
// Search within objects
struct Person {
    let name: String
    let age: Int
    let tags: [String]
}

let person = Person(name: "Alice Smith", age: 34, tags: ["engineer", "swift"])

matches(person, query: "swift")  // true
matches(person, query: "alice")  // true
matches(person, query: "35")     // false

// Find property by name
let person = Person(firstName: "Alice", lastName: "Smith", age: 30)
let lastNameValue = value(of: person) { $0 == "lastName" }
// lastNameValue: "Smith"
```

### Dependency Injection

```swift
protocol Container {
    func register(_ instance: Any)
}

protocol Injectable {
    init()
}

func autoWire(types: [Any.Type], into c: Container) {
    for type in types {
        if let injectableType = type as? Injectable.Type {
            let instance = injectableType.init()
            c.register(instance)
        }
    }
}

struct MyService: Injectable {
    init() { print("MyService initialized") }
}

let container = SimpleContainer()
autoWire(types: [MyService.self], into: container)
```

### Visualization

```swift
// Generate DOT graph
struct Node: TreeLike, CustomStringConvertible {
    var value: String
    var children: [Node]
    var description: String { value }
}

let tree = Node(value: "A", children: [
    Node(value: "B", children: []),
    Node(value: "C", children: [
        Node(value: "D", children: [])
    ])
])

let dotGraph = dot(tree)
// Output can be piped into Graphviz:
// swift run | dot -Tpng -o tree.png
```

### Utility Functions

```swift
// Randomize object properties
class Example {
    @objc var x: Int = 1
    @objc var y: Double = 3.14
    @objc var flag: Bool = false
    @objc var label: String = "test"
}

let original = Example()
let randomized = fuzz(original)
// Properties are randomized: x (0-1000), y (0-100), flag (true/false), label (random string)

// Get CSV column headers
struct Person: DefaultInitializable {
    var name: String = ""
    var age: Int = 0
    init() {}
}

let headers = columns(Person.self)
// headers: "name, age"

// KVC initialization from Objective-C objects
struct User: KVCInitialisable {
    var id: Int = 0
    var name: String = ""
}

class ObjCUser: NSObject {
    @objc var id = 0
    @objc var name = ""
}

let objcUser = ObjCUser()
objcUser.id = 42
objcUser.name = "Alice"
let swiftUser = User(objcUser)
// swiftUser.id == 42, swiftUser.name == "Alice"
```

## Advanced Features

### Trackable Properties

Mark specific properties for tracking using property wrappers:

```swift
@propertyWrapper struct TrackableProperty<Value>: TrackableField {
    var wrappedValue: Value
}

struct SignUpData {
    @TrackableProperty var email: String = ""
    @TrackableProperty var password: String = ""
    var rememberMe: Bool = false // not tracked
}

let formData = SignUpData()
let trackedFields = gatherFieldsToTrack(formData)
// trackedFields: ["email", "password"]
```

### Logging

Simple logging for enum cases:

```swift
protocol Loggable {}

enum FeedItem: Loggable {
    case text(String)
    case image(url: URL, caption: String?)
    case ad(id: UUID)
}

func log(_ item: Loggable) {
    let m = Mirror(reflecting: item)
    print("case:", String(describing: m.subjectType))
    if let child = m.children.first {
        print("label:", child.label ?? "(payload)")
        print("value:", child.value)
    }
}
```

## Requirements

- Swift 6.1+
- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Author

Created by Mateusz Kosikowski 