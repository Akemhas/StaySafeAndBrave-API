import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: any Database) async throws {
       try await database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("role", .string, .required)
            .field("created_at", .datetime)
            .unique(on: "email")
            .field("birth_date", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
       try await database.schema("users").delete()
    }
}
