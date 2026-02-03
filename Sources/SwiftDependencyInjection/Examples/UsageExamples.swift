//
//  UsageExamples.swift
//  SwiftDependencyInjection
//
//  Created by Muhittin Camdali on 2024.
//  Copyright © 2024 Muhittin Camdali. All rights reserved.
//

import Foundation

// MARK: - Example Protocols

/// Example protocol for a network service.
public protocol NetworkServiceProtocol {
    /// Fetches data from a URL.
    func fetch(url: URL) async throws -> Data
    
    /// Posts data to a URL.
    func post(url: URL, body: Data) async throws -> Data
    
    /// Downloads a file.
    func download(url: URL, to destination: URL) async throws
}

/// Example protocol for a storage service.
public protocol StorageServiceProtocol {
    /// Saves data with a key.
    func save(_ data: Data, forKey key: String) throws
    
    /// Loads data for a key.
    func load(forKey key: String) throws -> Data?
    
    /// Deletes data for a key.
    func delete(forKey key: String) throws
    
    /// Checks if data exists for a key.
    func exists(forKey key: String) -> Bool
}

/// Example protocol for an authentication service.
public protocol AuthServiceProtocol {
    /// The current user, if authenticated.
    var currentUser: UserProtocol? { get }
    
    /// Whether the user is authenticated.
    var isAuthenticated: Bool { get }
    
    /// Signs in with credentials.
    func signIn(email: String, password: String) async throws
    
    /// Signs out the current user.
    func signOut() throws
    
    /// Refreshes the authentication token.
    func refreshToken() async throws
}

/// Example protocol for a user.
public protocol UserProtocol {
    var id: String { get }
    var email: String { get }
    var displayName: String { get }
}

/// Example protocol for a logging service.
public protocol LoggingServiceProtocol {
    /// Logs a debug message.
    func debug(_ message: String, file: String, function: String, line: Int)
    
    /// Logs an info message.
    func info(_ message: String, file: String, function: String, line: Int)
    
    /// Logs a warning message.
    func warning(_ message: String, file: String, function: String, line: Int)
    
    /// Logs an error message.
    func error(_ message: String, file: String, function: String, line: Int)
}

/// Example protocol for analytics.
public protocol AnalyticsServiceProtocol {
    /// Tracks an event.
    func track(event: String, properties: [String: Any])
    
    /// Sets user properties.
    func setUserProperties(_ properties: [String: Any])
    
    /// Identifies a user.
    func identify(userId: String)
}

/// Example protocol for a cache service.
public protocol CacheServiceProtocol {
    /// Caches a value.
    func cache<T: Codable>(_ value: T, forKey key: String, ttl: TimeInterval?)
    
    /// Retrieves a cached value.
    func retrieve<T: Codable>(forKey key: String) -> T?
    
    /// Invalidates a cached value.
    func invalidate(forKey key: String)
    
    /// Clears the entire cache.
    func clear()
}

// MARK: - Example Implementations

/// Example implementation of NetworkServiceProtocol.
public final class URLSessionNetworkService: NetworkServiceProtocol {
    
    private let session: URLSession
    private let logger: LoggingServiceProtocol?
    
    public init(session: URLSession = .shared, logger: LoggingServiceProtocol? = nil) {
        self.session = session
        self.logger = logger
    }
    
    public func fetch(url: URL) async throws -> Data {
        logger?.info("Fetching: \(url)", file: #file, function: #function, line: #line)
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        return data
    }
    
    public func post(url: URL, body: Data) async throws -> Data {
        logger?.info("Posting to: \(url)", file: #file, function: #function, line: #line)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        return data
    }
    
    public func download(url: URL, to destination: URL) async throws {
        logger?.info("Downloading: \(url)", file: #file, function: #function, line: #line)
        let (tempURL, response) = try await session.download(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        try FileManager.default.moveItem(at: tempURL, to: destination)
    }
}

/// Network errors.
public enum NetworkError: Error, LocalizedError {
    case invalidResponse
    case unauthorized
    case serverError(statusCode: Int)
    case noConnection
    
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .unauthorized:
            return "Unauthorized access"
        case .serverError(let code):
            return "Server error: \(code)"
        case .noConnection:
            return "No network connection"
        }
    }
}

/// Example implementation of StorageServiceProtocol.
public final class FileStorageService: StorageServiceProtocol {
    
    private let baseDirectory: URL
    private let fileManager: FileManager
    
    public init(directory: URL? = nil, fileManager: FileManager = .default) {
        self.baseDirectory = directory ?? fileManager.temporaryDirectory.appendingPathComponent("Storage")
        self.fileManager = fileManager
        try? fileManager.createDirectory(at: self.baseDirectory, withIntermediateDirectories: true)
    }
    
    public func save(_ data: Data, forKey key: String) throws {
        let url = fileURL(for: key)
        try data.write(to: url)
    }
    
    public func load(forKey key: String) throws -> Data? {
        let url = fileURL(for: key)
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        return try Data(contentsOf: url)
    }
    
    public func delete(forKey key: String) throws {
        let url = fileURL(for: key)
        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }
    }
    
    public func exists(forKey key: String) -> Bool {
        fileManager.fileExists(atPath: fileURL(for: key).path)
    }
    
    private func fileURL(for key: String) -> URL {
        baseDirectory.appendingPathComponent(key.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? key)
    }
}

/// Example implementation of LoggingServiceProtocol.
public final class ConsoleLoggingService: LoggingServiceProtocol {
    
    public enum Level: String {
        case debug = "DEBUG"
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
    }
    
    private let minimumLevel: Level
    private let dateFormatter: DateFormatter
    
    public init(minimumLevel: Level = .debug) {
        self.minimumLevel = minimumLevel
        self.dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }
    
    public func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .debug, message: message, file: file, function: function, line: line)
    }
    
    public func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .info, message: message, file: file, function: function, line: line)
    }
    
    public func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .warning, message: message, file: file, function: function, line: line)
    }
    
    public func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(level: .error, message: message, file: file, function: function, line: line)
    }
    
    private func log(level: Level, message: String, file: String, function: String, line: Int) {
        guard shouldLog(level) else { return }
        let timestamp = dateFormatter.string(from: Date())
        let filename = (file as NSString).lastPathComponent
        print("[\(timestamp)] [\(level.rawValue)] [\(filename):\(line)] \(function) - \(message)")
    }
    
    private func shouldLog(_ level: Level) -> Bool {
        let levels: [Level] = [.debug, .info, .warning, .error]
        guard let minimumIndex = levels.firstIndex(of: minimumLevel),
              let levelIndex = levels.firstIndex(of: level) else {
            return false
        }
        return levelIndex >= minimumIndex
    }
}

/// Example implementation of CacheServiceProtocol.
public final class InMemoryCacheService: CacheServiceProtocol {
    
    private struct CacheEntry {
        let data: Data
        let expiresAt: Date?
    }
    
    private var cache: [String: CacheEntry] = [:]
    private let lock = NSLock()
    
    public init() {}
    
    public func cache<T: Codable>(_ value: T, forKey key: String, ttl: TimeInterval? = nil) {
        lock.lock()
        defer { lock.unlock() }
        
        guard let data = try? JSONEncoder().encode(value) else { return }
        let expiresAt = ttl.map { Date().addingTimeInterval($0) }
        cache[key] = CacheEntry(data: data, expiresAt: expiresAt)
    }
    
    public func retrieve<T: Codable>(forKey key: String) -> T? {
        lock.lock()
        defer { lock.unlock() }
        
        guard let entry = cache[key] else { return nil }
        
        if let expiresAt = entry.expiresAt, Date() > expiresAt {
            cache.removeValue(forKey: key)
            return nil
        }
        
        return try? JSONDecoder().decode(T.self, from: entry.data)
    }
    
    public func invalidate(forKey key: String) {
        lock.lock()
        defer { lock.unlock() }
        cache.removeValue(forKey: key)
    }
    
    public func clear() {
        lock.lock()
        defer { lock.unlock() }
        cache.removeAll()
    }
}

// MARK: - Example Modules

/// Example module for networking dependencies.
public struct NetworkingModule: DependencyModule {
    
    public init() {}
    
    public func register(in container: Container) {
        container.register(LoggingServiceProtocol.self, scope: .singleton) { _ in
            ConsoleLoggingService(minimumLevel: .debug)
        }
        
        container.register(NetworkServiceProtocol.self, scope: .singleton) { resolver in
            URLSessionNetworkService(
                session: .shared,
                logger: resolver.resolveOptional(LoggingServiceProtocol.self)
            )
        }
    }
}

/// Example module for storage dependencies.
public struct StorageModule: DependencyModule {
    
    private let directory: URL?
    
    public init(directory: URL? = nil) {
        self.directory = directory
    }
    
    public func register(in container: Container) {
        container.register(StorageServiceProtocol.self, scope: .singleton) { _ in
            FileStorageService(directory: self.directory)
        }
        
        container.register(CacheServiceProtocol.self, scope: .singleton) { _ in
            InMemoryCacheService()
        }
    }
}

/// Example composite application module.
public struct ApplicationModule: DependencyModule {
    
    public init() {}
    
    public func register(in container: Container) {
        NetworkingModule().register(in: container)
        StorageModule().register(in: container)
    }
}

// MARK: - Example Usage Patterns

/// Demonstrates basic container usage.
public enum BasicUsageExample {
    
    /// Shows how to register and resolve a simple service.
    public static func simpleRegistration() {
        let container = Container()
        
        // Register a service
        container.register(LoggingServiceProtocol.self, scope: .singleton) { _ in
            ConsoleLoggingService()
        }
        
        // Resolve the service
        let logger: LoggingServiceProtocol = container.resolve(LoggingServiceProtocol.self)
        logger.info("Hello, DI!", file: #file, function: #function, line: #line)
    }
    
    /// Shows how to register services with dependencies.
    public static func serviceWithDependencies() {
        let container = Container()
        
        // Register logger first
        container.register(LoggingServiceProtocol.self, scope: .singleton) { _ in
            ConsoleLoggingService()
        }
        
        // Register network service that depends on logger
        container.register(NetworkServiceProtocol.self, scope: .singleton) { resolver in
            URLSessionNetworkService(
                session: .shared,
                logger: resolver.resolve(LoggingServiceProtocol.self)
            )
        }
        
        // Resolve - dependencies are automatically injected
        let network: NetworkServiceProtocol = container.resolve(NetworkServiceProtocol.self)
        _ = network // Use network service
    }
    
    /// Shows how to use named registrations.
    public static func namedRegistrations() {
        let container = Container()
        
        // Register multiple implementations with names
        container.register(LoggingServiceProtocol.self, name: "console", scope: .singleton) { _ in
            ConsoleLoggingService(minimumLevel: .debug)
        }
        
        container.register(LoggingServiceProtocol.self, name: "production", scope: .singleton) { _ in
            ConsoleLoggingService(minimumLevel: .warning)
        }
        
        // Resolve by name
        let debugLogger: LoggingServiceProtocol = container.resolve(LoggingServiceProtocol.self, name: "console")
        let prodLogger: LoggingServiceProtocol = container.resolve(LoggingServiceProtocol.self, name: "production")
        
        debugLogger.debug("Debug message", file: #file, function: #function, line: #line)
        prodLogger.debug("This won't be logged", file: #file, function: #function, line: #line)
    }
}

/// Demonstrates module-based registration.
public enum ModuleUsageExample {
    
    /// Shows how to use modules for organizing registrations.
    public static func usingModules() {
        let container = Container()
        
        // Load modules
        container.load(module: NetworkingModule())
        container.load(module: StorageModule())
        
        // Services are now available
        let network: NetworkServiceProtocol = container.resolve(NetworkServiceProtocol.self)
        let storage: StorageServiceProtocol = container.resolve(StorageServiceProtocol.self)
        
        _ = network
        _ = storage
    }
    
    /// Shows how to use composite modules.
    public static func compositeModule() {
        let container = Container()
        
        // Single module loads all dependencies
        container.load(module: ApplicationModule())
        
        // All services are available
        let logger: LoggingServiceProtocol = container.resolve(LoggingServiceProtocol.self)
        let network: NetworkServiceProtocol = container.resolve(NetworkServiceProtocol.self)
        let storage: StorageServiceProtocol = container.resolve(StorageServiceProtocol.self)
        let cache: CacheServiceProtocol = container.resolve(CacheServiceProtocol.self)
        
        _ = logger
        _ = network
        _ = storage
        _ = cache
    }
}

/// Demonstrates scope usage.
public enum ScopeUsageExample {
    
    /// Shows the difference between singleton and transient scopes.
    public static func scopeDifferences() {
        let container = Container()
        
        // Singleton: same instance every time
        container.register(CacheServiceProtocol.self, scope: .singleton) { _ in
            InMemoryCacheService()
        }
        
        // Transient: new instance every time
        container.register(StorageServiceProtocol.self, scope: .transient) { _ in
            FileStorageService()
        }
        
        // Same instance
        let cache1: CacheServiceProtocol = container.resolve(CacheServiceProtocol.self)
        let cache2: CacheServiceProtocol = container.resolve(CacheServiceProtocol.self)
        // cache1 === cache2 (same object)
        
        // Different instances
        let storage1: StorageServiceProtocol = container.resolve(StorageServiceProtocol.self)
        let storage2: StorageServiceProtocol = container.resolve(StorageServiceProtocol.self)
        // storage1 !== storage2 (different objects)
        
        _ = cache1
        _ = cache2
        _ = storage1
        _ = storage2
    }
}

/// Demonstrates hierarchical containers.
public enum HierarchyUsageExample {
    
    /// Shows how to use parent-child containers.
    public static func parentChildContainers() {
        // Parent container with shared services
        let parent = Container()
        parent.register(LoggingServiceProtocol.self, scope: .singleton) { _ in
            ConsoleLoggingService()
        }
        
        // Child container inherits from parent
        let child = Container(parent: parent)
        child.register(CacheServiceProtocol.self, scope: .singleton) { _ in
            InMemoryCacheService()
        }
        
        // Child can resolve from parent
        let logger: LoggingServiceProtocol = child.resolve(LoggingServiceProtocol.self)
        let cache: CacheServiceProtocol = child.resolve(CacheServiceProtocol.self)
        
        _ = logger
        _ = cache
    }
    
    /// Shows how to override parent registrations.
    public static func overridingParentRegistrations() {
        let parent = Container()
        parent.register(LoggingServiceProtocol.self, scope: .singleton) { _ in
            ConsoleLoggingService(minimumLevel: .warning)
        }
        
        let child = Container(parent: parent)
        child.register(LoggingServiceProtocol.self, scope: .singleton) { _ in
            ConsoleLoggingService(minimumLevel: .debug) // Override with debug logger
        }
        
        // Parent uses warning level
        let parentLogger: LoggingServiceProtocol = parent.resolve(LoggingServiceProtocol.self)
        
        // Child uses debug level (overridden)
        let childLogger: LoggingServiceProtocol = child.resolve(LoggingServiceProtocol.self)
        
        _ = parentLogger
        _ = childLogger
    }
}

// MARK: - Thread Safety Examples

/// Demonstrates thread-safe container usage.
public enum ThreadSafeUsageExample {
    
    /// Shows how to use ThreadSafeContainer.
    public static func threadSafeAccess() {
        let container = ThreadSafeContainer()
        
        // Register services (thread-safe)
        container.register(CacheServiceProtocol.self) { _ in
            InMemoryCacheService()
        }
        
        // Resolve from multiple threads
        DispatchQueue.concurrentPerform(iterations: 100) { _ in
            let cache: CacheServiceProtocol = container.resolve(CacheServiceProtocol.self)
            cache.cache("value", forKey: "key", ttl: 60)
        }
    }
}
