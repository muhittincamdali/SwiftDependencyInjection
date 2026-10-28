import SwiftDiagnostics
import SwiftSyntax

/// What `@DependencyContainer` reads from the class body.
struct ContainerModel {
    enum Lifetime: String {
        case shared
        case transient
    }

    struct Dependency {
        /// The name as `#function` reports it, without backticks: the storage key.
        let name: String
        /// The name as declared, with backticks if it has them, for generated declarations.
        let declaredName: String
        let type: String
        let lifetime: Lifetime
        /// Access modifier for the override field: the property's own access, never `private`
        /// (a private field could not be set from outside the nested struct).
        let fieldAccess: String
    }

    /// A computed property of the class, a dependency or not, and the members it reads directly.
    struct Member {
        let name: String
        let nameToken: TokenSyntax
        let isDependency: Bool
        let reads: [String]
    }

    var dependencies: [Dependency] = []
    var members: [Member] = []
    var diagnostics: [Diagnostic] = []

    /// The names of the providers a getter may call.
    static let providerNames: Set<String> = ["shared", "transient"]

    /// Names the macro adds to the class.
    static let generatedNames: Set<String> = ["dependencyStorage", "Overrides", "override", "dependencyGraph"]

    init(members memberList: MemberBlockItemListSyntax) {
        for item in memberList {
            let decl = item.decl
            if let variable = decl.as(VariableDeclSyntax.self) {
                readVariable(variable)
            } else {
                checkReservedName(of: decl)
                reportProviderCalls(in: Syntax(decl))
            }
        }
    }

    // MARK: - Members

    private mutating func readVariable(_ variable: VariableDeclSyntax) {
        let isStatic = variable.modifiers.contains { ["static", "class"].contains($0.name.text) }
        for binding in variable.bindings {
            guard let identifier = binding.pattern.as(IdentifierPatternSyntax.self) else {
                reportProviderCalls(in: Syntax(binding))
                continue
            }
            let name = Self.plainName(identifier.identifier)
            if Self.generatedNames.contains(name) {
                diagnose(identifier, .reservedName(name))
                continue
            }
            guard let accessors = binding.accessorBlock else {
                // A stored property. A provider call in its initializer would run with the
                // property name as the key but outside a getter.
                if let initializer = binding.initializer {
                    reportProviderCalls(in: Syntax(initializer))
                }
                continue
            }
            if isStatic {
                if let call = Self.firstProviderCall(in: Syntax(accessors)) {
                    diagnose(call, .staticProvider(name))
                }
                continue
            }
            readComputedProperty(variable, binding: binding, name: name, nameToken: identifier.identifier, accessors: accessors)
        }
    }

    private mutating func readComputedProperty(
        _ variable: VariableDeclSyntax,
        binding: PatternBindingSyntax,
        name: String,
        nameToken: TokenSyntax,
        accessors: AccessorBlockSyntax
    ) {
        let getter: (statements: CodeBlockItemListSyntax, accessor: AccessorDeclSyntax?)?
        var hasSetter = false
        switch accessors.accessors {
        case let .getter(statements):
            getter = (statements, nil)
        case let .accessors(list):
            let get = list.first { $0.accessorSpecifier.tokenKind == .keyword(.get) }
            hasSetter = list.contains { $0.accessorSpecifier.tokenKind != .keyword(.get) }
            getter = get?.body.map { ($0.statements, get) }
        }
        guard let getter else { return }

        guard let call = Self.soleProviderCall(in: getter.statements) else {
            if let stray = Self.firstProviderCall(in: Syntax(getter.statements)) {
                let provider = Self.providerName(of: stray) ?? "shared"
                diagnose(stray, .providerNotSoleStatement(provider))
            }
            members.append(Member(
                name: name,
                nameToken: nameToken,
                isDependency: false,
                reads: ReferenceCollector.reads(in: Syntax(getter.statements))
            ))
            return
        }

        let provider = Self.providerName(of: call) ?? "shared"
        if call.arguments.contains(where: { $0.label?.text == "key" }) {
            diagnose(call, .explicitKey(provider))
        }
        if hasSetter {
            diagnose(nameToken, .writableDependency(name))
        }
        if let effects = getter.accessor?.effectSpecifiers,
           effects.asyncSpecifier != nil || effects.throwsClause != nil {
            diagnose(nameToken, .effectfulGetter(name))
        }
        guard let type = binding.typeAnnotation?.type else { return }
        if type.is(SomeOrAnyTypeSyntax.self), type.as(SomeOrAnyTypeSyntax.self)?.someOrAnySpecifier.text == "some" {
            diagnose(type, .opaqueType(name))
            return
        }

        let body = Self.providerClosure(of: call).map { Syntax($0.statements) } ?? Syntax(call.arguments)
        members.append(Member(
            name: name,
            nameToken: nameToken,
            isDependency: true,
            reads: ReferenceCollector.reads(in: body)
        ))
        dependencies.append(Dependency(
            name: name,
            declaredName: nameToken.text,
            type: Self.overrideType(type),
            lifetime: provider == "transient" ? .transient : .shared,
            fieldAccess: Self.fieldAccess(of: variable.modifiers)
        ))
    }

    private mutating func checkReservedName(of decl: DeclSyntax) {
        let token: TokenSyntax? = if let function = decl.as(FunctionDeclSyntax.self) {
            function.name
        } else if let type = decl.as(StructDeclSyntax.self) {
            type.name
        } else if let type = decl.as(ClassDeclSyntax.self) {
            type.name
        } else if let type = decl.as(EnumDeclSyntax.self) {
            type.name
        } else if let alias = decl.as(TypeAliasDeclSyntax.self) {
            alias.name
        } else {
            nil
        }
        guard let token else { return }
        let name = Self.plainName(token)
        // An `override` method with other parameters would be an overload, not a clash, but a
        // second `override(_:)` would be; keep the rule simple and reserve the name.
        if Self.generatedNames.contains(name) {
            diagnose(token, .reservedName(name))
        }
    }

    /// Reports every provider call in a member that is not a computed property getter.
    private mutating func reportProviderCalls(in node: Syntax) {
        for call in ProviderCallFinder.calls(in: node) {
            diagnose(call, .providerOutsideGetter(Self.providerName(of: call) ?? "shared"))
        }
    }

    private mutating func diagnose(_ node: some SyntaxProtocol, _ message: ContainerDiagnostic) {
        diagnostics.append(Diagnostic(node: Syntax(node), message: message))
    }

    // MARK: - Syntax helpers

    /// The provider call when the getter consists of exactly `shared { … }`, `transient { … }`
    /// or the same with `return` or `self.`.
    static func soleProviderCall(in statements: CodeBlockItemListSyntax) -> FunctionCallExprSyntax? {
        guard statements.count == 1, let item = statements.first?.item else { return nil }
        let expression: ExprSyntax? = if let expr = item.as(ExprSyntax.self) {
            expr
        } else if let returnStatement = item.as(ReturnStmtSyntax.self) {
            returnStatement.expression
        } else if let statement = item.as(ExpressionStmtSyntax.self) {
            statement.expression
        } else {
            nil
        }
        guard let call = expression?.as(FunctionCallExprSyntax.self), providerName(of: call) != nil else {
            return nil
        }
        return call
    }

    static func firstProviderCall(in node: Syntax) -> FunctionCallExprSyntax? {
        ProviderCallFinder.calls(in: node).first
    }

    /// `shared` or `transient` when `call` calls one of them on the container itself.
    static func providerName(of call: FunctionCallExprSyntax) -> String? {
        let name: String
        if let reference = call.calledExpression.as(DeclReferenceExprSyntax.self) {
            name = reference.baseName.text
        } else if let member = call.calledExpression.as(MemberAccessExprSyntax.self),
                  member.base?.as(DeclReferenceExprSyntax.self)?.baseName.tokenKind == .keyword(.self) {
            name = member.declName.baseName.text
        } else {
            return nil
        }
        return providerNames.contains(name) ? name : nil
    }

    static func providerClosure(of call: FunctionCallExprSyntax) -> ClosureExprSyntax? {
        call.trailingClosure ?? call.arguments.last?.expression.as(ClosureExprSyntax.self)
    }

    /// The type of an override closure's result. An implicitly unwrapped optional cannot be a
    /// closure result, so `T!` becomes `T?`.
    static func overrideType(_ type: TypeSyntax) -> String {
        if let unwrapped = type.as(ImplicitlyUnwrappedOptionalTypeSyntax.self) {
            return "\(unwrapped.wrappedType.trimmedDescription)?"
        }
        return type.trimmedDescription
    }

    static func fieldAccess(of modifiers: DeclModifierListSyntax) -> String {
        for modifier in modifiers where modifier.detail == nil {
            switch modifier.name.text {
            case "public", "open": return "public "
            case "package": return "package "
            case "fileprivate", "private": return "fileprivate "
            case "internal": return ""
            default: continue
            }
        }
        return ""
    }

    /// The identifier without backticks, as `#function` reports it.
    static func plainName(_ token: TokenSyntax) -> String {
        token.text.trimmingCharacters(in: "`")
    }
}

private extension String {
    func trimmingCharacters(in character: Character) -> String {
        var result = Substring(self)
        while result.first == character { result.removeFirst() }
        while result.last == character { result.removeLast() }
        return String(result)
    }
}

/// Finds calls to `shared` and `transient` on the container anywhere below a node.
final class ProviderCallFinder: SyntaxVisitor {
    private(set) var found: [FunctionCallExprSyntax] = []

    static func calls(in node: Syntax) -> [FunctionCallExprSyntax] {
        let finder = ProviderCallFinder(viewMode: .sourceAccurate)
        finder.walk(node)
        return finder.found
    }

    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        if ContainerModel.providerName(of: node) != nil {
            found.append(node)
        }
        return .visitChildren
    }

    // A nested type has its own members; its `shared` is not the container's.
    override func visit(_: StructDeclSyntax) -> SyntaxVisitorContinueKind { .skipChildren }
    override func visit(_: ClassDeclSyntax) -> SyntaxVisitorContinueKind { .skipChildren }
    override func visit(_: EnumDeclSyntax) -> SyntaxVisitorContinueKind { .skipChildren }
    override func visit(_: ActorDeclSyntax) -> SyntaxVisitorContinueKind { .skipChildren }
}
