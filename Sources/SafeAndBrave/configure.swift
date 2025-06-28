import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Configure database
    try configureDatabase(app)
    
    // Add migrations
    addMigrations(app)
    
    // Auto-migrate only in development or when explicitly requested
    if app.environment == .development || Environment.get("AUTO_MIGRATE") == "true" {
        try await app.autoMigrate()
    }

    // Configure Leaf templating
    app.views.use(.leaf)

    // Register routes
    try routes(app)
}

private func configureDatabase(_ app: Application) throws {
    // Check if DATABASE_URL is provided (typical for production deployments like Render.com)
    if let databaseURL = Environment.get("DATABASE_URL") {
        try configureDatabaseFromURL(app, databaseURL: databaseURL)
    } else {
        // Use individual environment variables (typical for local development)
        configureDatabaseFromEnvironment(app)
    }
}

private func configureDatabaseFromURL(_ app: Application, databaseURL: String) throws {
    guard let url = URL(string: databaseURL) else {
        throw Abort(.internalServerError, reason: "Invalid DATABASE_URL format")
    }
    
    let hostname = url.host ?? "localhost"
    let port = url.port ?? SQLPostgresConfiguration.ianaPortNumber
    let username = url.user ?? "vapor_username"
    let password = url.password ?? "vapor_password"
    let database = String(url.path.dropFirst()) // Remove leading "/"
    
    // Configure TLS for production (Render.com requires TLS)
    var tlsConfig = TLSConfiguration.clientDefault
    tlsConfig.certificateVerification = .none
    let tlsConfiguration = try NIOSSLContext(configuration: tlsConfig)
    
    let postgresConfig = SQLPostgresConfiguration(
        hostname: hostname,
        port: port,
        username: username,
        password: password,
        database: database,
        tls: .prefer(tlsConfiguration)
    )
    
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: postgresConfig), as: .psql)
    
    app.logger.info("Database configured from DATABASE_URL: \(hostname):\(port)/\(database)")
}

private func configureDatabaseFromEnvironment(_ app: Application) {
    let hostname = Environment.get("DATABASE_HOST") ?? "localhost"
    let port = Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber
    let username = Environment.get("DATABASE_USERNAME") ?? "vapor_username"
    let password = Environment.get("DATABASE_PASSWORD") ?? "vapor_password"
    let database = Environment.get("DATABASE_NAME") ?? "vapor_database"
    
    // For local development, TLS is optional
    let tlsConfiguration: PostgresConnection.Configuration.TLS
    if app.environment == .production {
        // Use TLS in production
        var tlsConfig = TLSConfiguration.clientDefault
        tlsConfig.certificateVerification = .none
        tlsConfiguration = .prefer(try! NIOSSLContext(configuration: tlsConfig))
    } else {
        // No TLS for local development
        tlsConfiguration = .disable
    }
    
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: hostname,
        port: port,
        username: username,
        password: password,
        database: database,
        tls: tlsConfiguration
    )), as: .psql)
    
    app.logger.info("Database configured from environment: \(hostname):\(port)/\(database)")
}

private func addMigrations(_ app: Application) {
    app.migrations.add(CreateTodo())
    app.migrations.add(CreateUser())
    app.migrations.add(CreateMentor())
    app.migrations.add(CreateBooking())
    app.migrations.add(CreateReport())
    app.migrations.add(CreatePackage())
    app.migrations.add(CreateFAQ())
    app.migrations.add(CreateTeamMember())
}
