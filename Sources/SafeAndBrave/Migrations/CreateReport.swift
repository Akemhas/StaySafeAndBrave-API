import Fluent

struct CreateReport: AsyncMigration {
    func prepare(on database: any Database) async throws {
       try await database.schema("reports")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("text", .string, .required)
            .field("picture_url", .string, .required)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: any Database) async throws {
       try await database.schema("reports").delete()
    }
}