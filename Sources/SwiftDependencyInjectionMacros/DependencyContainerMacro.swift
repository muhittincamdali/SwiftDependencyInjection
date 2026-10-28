import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

/// `@DependencyContainer`: adds the storage, typed overrides and the dependency graph to a final
/// class, and reports dependency cycles and misuse at compile time.
public struct DependencyContainerMacro: MemberMacro, ExtensionMacro {
    private static let module = "SwiftDependencyInjection"

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo _: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let classDecl = declaration.as(ClassDeclSyntax.self) else {
            context.diagnose(Diagnostic(node: Syntax(node), message: ContainerDiagnostic.notAClass))
            return []
        }
        guard classDecl.modifiers.contains(where: { $0.name.tokenKind == .keyword(.final) }) else {
            context.diagnose(notFinalDiagnostic(for: classDecl))
            return []
        }

        let model = ContainerModel(members: classDecl.memberBlock.members)
        model.diagnostics.forEach(context.diagnose)

        let graph = GraphAnalysis(members: model.members)
        let tokens = Dictionary(model.members.map { ($0.name, $0.nameToken) }, uniquingKeysWith: { first, _ in first })
        for cycle in graph.cycles() {
            guard let token = tokens[cycle[0]] else { continue }
            context.diagnose(Diagnostic(node: Syntax(token), message: ContainerDiagnostic.cycle(cycle)))
        }

        let access = typeAccess(of: classDecl.modifiers)
        let isMainActor = classDecl.attributes.contains { attribute in
            attribute.as(AttributeSyntax.self)?.attributeName.trimmedDescription == "MainActor"
        }
        return [
            "\(raw: access)nonisolated let dependencyStorage = \(raw: module).DependencyStorage()",
            overridesStruct(model.dependencies, access: access, isMainActor: isMainActor),
            overrideMethod(model.dependencies, access: access),
            graphProperty(model.dependencies, graph: graph, container: classDecl.name.text, access: access),
        ]
    }

    public static func expansion(
        of _: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in _: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        // The member expansion reports what is wrong with other declarations; adding the
        // conformance there too would only repeat the error.
        guard let classDecl = declaration.as(ClassDeclSyntax.self),
              classDecl.modifiers.contains(where: { $0.name.tokenKind == .keyword(.final) }),
              !protocols.isEmpty
        else { return [] }
        let decl: DeclSyntax = "extension \(type.trimmed): \(raw: module).DependencyContainer {}"
        return decl.as(ExtensionDeclSyntax.self).map { [$0] } ?? []
    }

    // MARK: - Generated members

    private static func overridesStruct(
        _ dependencies: [ContainerModel.Dependency],
        access: String,
        isMainActor: Bool
    ) -> DeclSyntax {
        let isolation = isMainActor ? "@MainActor" : "@Sendable"
        let fields = dependencies.map { dependency in
            "    /// Replaces `\(dependency.name)`.\n"
                + "    \(dependency.fieldAccess)var \(dependency.declaredName): (\(isolation) () -> \(dependency.type))?"
        }
        let body = (fields + ["    \(access)init() {}"]).joined(separator: "\n\n")
        return """
            /// Replacements for the dependencies of this container, for tests and previews. Each
            /// field is a closure that builds the replacement; leave a field `nil` to keep the
            /// real dependency.
            \(raw: access)struct Overrides {
            \(raw: body)
            }
            """
    }

    private static func overrideMethod(_ dependencies: [ContainerModel.Dependency], access: String) -> DeclSyntax {
        let applies = dependencies.map { dependency in
            let key = StringLiteralExprSyntax(content: dependency.name)
            return "    if let make = overrides.\(dependency.declaredName) {\n"
                + "        dependencyStorage._setOverride(for: \(key)) { make() }\n"
                + "    }"
        }
        let body = (["    var overrides = Overrides()", "    configure(&overrides)"] + applies)
            .joined(separator: "\n")
        return """
            /// Replaces dependencies of this container, for example with test doubles.
            ///
            /// Call it before the dependencies are read. A shared instance that was already
            /// built is dropped, so the next read builds the replacement; objects that already
            /// hold the old instance keep it.
            \(raw: access)func override(_ configure: (inout Overrides) -> Void) {
            \(raw: body)
            }
            """
    }

    private static func graphProperty(
        _ dependencies: [ContainerModel.Dependency],
        graph: GraphAnalysis,
        container: String,
        access: String
    ) -> DeclSyntax {
        let nodes = dependencies.map { dependency in
            "\(module).DependencyGraph.Node(name: \(StringLiteralExprSyntax(content: dependency.name)), "
                + "type: \(StringLiteralExprSyntax(content: dependency.type)), "
                + "lifetime: .\(dependency.lifetime.rawValue))"
        }
        let edges = dependencies.flatMap { dependency in
            graph.dependencyEdges(from: dependency.name).map { target in
                "\(module).DependencyGraph.Edge(from: \(StringLiteralExprSyntax(content: dependency.name)), "
                    + "to: \(StringLiteralExprSyntax(content: target)))"
            }
        }
        return """
            /// The dependencies of this container and the reads between them, written at compile
            /// time by `@DependencyContainer`.
            \(raw: access)nonisolated static var dependencyGraph: \(raw: module).DependencyGraph {
                \(raw: module).DependencyGraph(
                    container: \(StringLiteralExprSyntax(content: container)),
                    nodes: \(raw: arrayLiteral(nodes)),
                    edges: \(raw: arrayLiteral(edges))
                )
            }
            """
    }

    private static func arrayLiteral(_ elements: [String]) -> String {
        guard !elements.isEmpty else { return "[]" }
        return "[\n" + elements.map { "            \($0)," }.joined(separator: "\n") + "\n        ]"
    }

    // MARK: - Helpers

    /// The access level of the generated members: that of the class, so a public container has
    /// public overrides.
    private static func typeAccess(of modifiers: DeclModifierListSyntax) -> String {
        for modifier in modifiers {
            switch modifier.name.text {
            case "public", "open": return "public "
            case "package": return "package "
            default: continue
            }
        }
        return ""
    }

    private static func notFinalDiagnostic(for classDecl: ClassDeclSyntax) -> Diagnostic {
        let final = DeclModifierSyntax(name: .keyword(.final, trailingTrivia: .space))
        let modifiers = classDecl.modifiers + [final]
        return Diagnostic(
            node: Syntax(classDecl.classKeyword),
            message: ContainerDiagnostic.notFinal,
            fixIt: FixIt(
                message: AddFinalFixIt(),
                changes: [.replace(oldNode: Syntax(classDecl.modifiers), newNode: Syntax(modifiers))]
            )
        )
    }
}
