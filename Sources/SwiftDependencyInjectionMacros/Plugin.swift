import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SwiftDependencyInjectionPlugin: CompilerPlugin {
    let providingMacros: [any Macro.Type] = [DependencyContainerMacro.self]
}
