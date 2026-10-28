import SwiftSyntax

/// Collects the names a getter or provider closure reads from `self` while it runs.
///
/// It is deliberately conservative, because a reported cycle stops the build:
///
/// - Only `name` and `self.name` count; `other.name` reads another value.
/// - Reads inside nested closures and local functions do not count: those may run later, for
///   example as a callback, when building has finished. The run-time check covers them.
/// - A name declared locally anywhere in the body (a `let`, a closure parameter, an `if let`)
///   does not count, even where it would still refer to the property.
final class ReferenceCollector: SyntaxVisitor {
    private var referenced: [String] = []
    private var declaredLocally: Set<String> = []

    static func reads(in node: Syntax) -> [String] {
        let collector = ReferenceCollector(viewMode: .sourceAccurate)
        collector.walk(node)
        var seen: Set<String> = []
        return collector.referenced.filter { name in
            !collector.declaredLocally.contains(name) && seen.insert(name).inserted
        }
    }

    override func visit(_ node: DeclReferenceExprSyntax) -> SyntaxVisitorContinueKind {
        if let member = node.parent?.as(MemberAccessExprSyntax.self), member.declName.id == node.id {
            // `x.name`: a read from self only when `x` is `self`.
            if member.base?.as(DeclReferenceExprSyntax.self)?.baseName.tokenKind == .keyword(.self) {
                record(node.baseName)
            }
            return .skipChildren
        }
        if node.baseName.tokenKind == .keyword(.self) || node.baseName.tokenKind == .keyword(.Self) {
            return .skipChildren
        }
        record(node.baseName)
        return .skipChildren
    }

    override func visit(_ node: IdentifierPatternSyntax) -> SyntaxVisitorContinueKind {
        declaredLocally.insert(ContainerModel.plainName(node.identifier))
        return .visitChildren
    }

    // `\.name` names a property without reading it.
    override func visit(_: KeyPathExprSyntax) -> SyntaxVisitorContinueKind { .skipChildren }
    override func visit(_: ClosureExprSyntax) -> SyntaxVisitorContinueKind { .skipChildren }
    override func visit(_: FunctionDeclSyntax) -> SyntaxVisitorContinueKind { .skipChildren }
    override func visit(_: StructDeclSyntax) -> SyntaxVisitorContinueKind { .skipChildren }
    override func visit(_: ClassDeclSyntax) -> SyntaxVisitorContinueKind { .skipChildren }
    override func visit(_: EnumDeclSyntax) -> SyntaxVisitorContinueKind { .skipChildren }
    override func visit(_: ActorDeclSyntax) -> SyntaxVisitorContinueKind { .skipChildren }

    private func record(_ token: TokenSyntax) {
        referenced.append(ContainerModel.plainName(token))
    }
}
