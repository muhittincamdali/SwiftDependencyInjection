import SwiftDependencyInjectionMacros
import SwiftDiagnostics
import SwiftParser
import SwiftSyntax
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros
import SwiftSyntaxMacrosGenericTestSupport
import Testing

/// Runs `assertMacroExpansion` with Swift Testing as the failure reporter.
func assertContainerExpansion(
    _ original: String,
    expandedSource: String,
    diagnostics: [DiagnosticSpec] = [],
    fixedSource: String? = nil,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) {
    assertMacroExpansion(
        original,
        expandedSource: expandedSource,
        diagnostics: diagnostics,
        macroSpecs: [
            "DependencyContainer": MacroSpec(
                type: DependencyContainerMacro.self,
                conformances: ["DependencyContainer"]
            ),
        ],
        fixedSource: fixedSource,
        indentationWidth: .spaces(4),
        failureHandler: { failure in
            Issue.record(Comment(rawValue: failure.message), sourceLocation: sourceLocation)
        }
    )
}

/// The extensions `@DependencyContainer` adds to the first declaration of `source` when the
/// compiler reports `missingConformances` as not yet declared.
func containerExtensions(_ source: String, missingConformances: [String]) throws -> [String] {
    let file = Parser.parse(source: source)
    let declaration = try #require(file.statements.first?.item.as(DeclSyntax.self))
    let group = try #require(declaration.asProtocol(DeclGroupSyntax.self))
    let attribute = try #require(group.attributes.first?.as(AttributeSyntax.self))
    let name = try #require(declaration.as(ClassDeclSyntax.self)?.name.text)
    let extensions = try DependencyContainerMacro.expansion(
        of: attribute,
        attachedTo: group,
        providingExtensionsOf: TypeSyntax(stringLiteral: name),
        conformingTo: missingConformances.map { TypeSyntax(stringLiteral: $0) },
        in: BasicMacroExpansionContext()
    )
    return extensions.map(\.trimmedDescription)
}

/// The result of running the member expansion on the first type in `source`.
struct ContainerExpansion {
    /// Diagnostic messages, each prefixed with `line:column` of the node it points at.
    let diagnostics: [String]
    /// The generated members, joined by blank lines.
    let members: String

    var messages: [String] {
        diagnostics.map { $0.split(separator: " ", maxSplits: 1).last.map(String.init) ?? $0 }
    }
}

/// Expands `@DependencyContainer` on the first declaration of `source` without the snapshot of
/// `assertMacroExpansion`, for tests that only look at diagnostics or at one generated member.
func expandContainer(_ source: String) throws -> ContainerExpansion {
    let file = Parser.parse(source: source)
    let declaration = try #require(file.statements.first?.item.as(DeclSyntax.self))
    let group = try #require(declaration.asProtocol(DeclGroupSyntax.self))
    let attribute = try #require(group.attributes.first?.as(AttributeSyntax.self))
    let context = BasicMacroExpansionContext(
        sourceFiles: [file: .init(moduleName: "Tests", fullFilePath: "Test.swift")]
    )
    let members = try DependencyContainerMacro.expansion(
        of: attribute,
        providingMembersOf: group,
        conformingTo: [],
        in: context
    )
    let converter = SourceLocationConverter(fileName: "Test.swift", tree: file)
    let diagnostics = context.diagnostics.map { diagnostic in
        let location = diagnostic.location(converter: converter)
        return "\(location.line):\(location.column) \(diagnostic.message)"
    }
    return ContainerExpansion(
        diagnostics: diagnostics,
        members: members.map(\.description).joined(separator: "\n\n")
    )
}
