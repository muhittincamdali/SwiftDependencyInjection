import SwiftDiagnostics

/// The errors `@DependencyContainer` reports. Each message says what is wrong and how to fix it.
enum ContainerDiagnostic: DiagnosticMessage {
    case notAClass
    case notFinal
    case reservedName(String)
    case cycle([String])
    case providerOutsideGetter(String)
    case providerNotSoleStatement(String)
    case providerInConditionalBlock(String)
    case wrongKeyPath(provider: String, name: String)
    case writableDependency(String)
    case effectfulGetter(String)
    case opaqueType(String)
    case staticProvider(String)

    var message: String {
        switch self {
        case .notAClass:
            "@DependencyContainer can only be attached to a final class"
        case .notFinal:
            "A dependency container must be a final class, so that its dependencies cannot be "
                + "replaced by a subclass the macro does not see"
        case let .reservedName(name):
            "'\(name)' is added by @DependencyContainer; rename this member"
        case let .cycle(path):
            "Dependency cycle: \(path.joined(separator: " → ")). '\(path[0])' needs itself while "
                + "it is being built; pass one side a closure that reads the other later, or move "
                + "the shared part into its own dependency"
        case let .providerOutsideGetter(name):
            "'\(name)' can only be called from the getter of a computed property, with the key "
                + "path of that property"
        case let .providerNotSoleStatement(name):
            "Write the getter as a single '\(name)(\\.property) { … }' call and put the other "
                + "statements inside the closure"
        case let .providerInConditionalBlock(name):
            "A dependency cannot be declared inside '#if', because @DependencyContainer cannot tell "
                + "which branch is built; declare it once and put the '#if' inside the closure passed "
                + "to '\(name)'"
        case let .wrongKeyPath(provider, name):
            "Pass '\\.\(name)' to '\(provider)': the key path of the property whose getter calls it "
                + "is the key of the instance and the key of its override"
        case let .writableDependency(name):
            "Dependency '\(name)' cannot have a setter; replace it in tests with override(_:)"
        case let .effectfulGetter(name):
            "Dependency '\(name)' must have a synchronous, non-throwing getter; dependencies are "
                + "built when they are read"
        case let .opaqueType(name):
            "Dependency '\(name)' cannot have an opaque 'some' type, because an override has to "
                + "name the type; use 'any' or a concrete type"
        case let .staticProvider(name):
            "Static property '\(name)' cannot be a dependency; dependencies belong to a "
                + "container instance"
        }
    }

    var diagnosticID: MessageID {
        let id = switch self {
        case .notAClass: "notAClass"
        case .notFinal: "notFinal"
        case .reservedName: "reservedName"
        case .cycle: "cycle"
        case .providerOutsideGetter: "providerOutsideGetter"
        case .providerNotSoleStatement: "providerNotSoleStatement"
        case .providerInConditionalBlock: "providerInConditionalBlock"
        case .wrongKeyPath: "wrongKeyPath"
        case .writableDependency: "writableDependency"
        case .effectfulGetter: "effectfulGetter"
        case .opaqueType: "opaqueType"
        case .staticProvider: "staticProvider"
        }
        return MessageID(domain: "SwiftDependencyInjection", id: id)
    }

    var severity: DiagnosticSeverity { .error }
}

/// The fix-it that adds `final` to a container class.
struct AddFinalFixIt: FixItMessage {
    var message: String { "Add 'final'" }
    var fixItID: MessageID { MessageID(domain: "SwiftDependencyInjection", id: "addFinal") }
}
