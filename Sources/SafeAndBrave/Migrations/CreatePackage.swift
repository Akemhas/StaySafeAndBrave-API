import Fluent

struct CreatePackage: AsyncMigration {
    func prepare(on database: any Database) async throws {
       try await database.schema("packages")
            .id()
            .field("mentor_id", .uuid, .required, .references("mentors", "id", onDelete: .cascade))
            .field("title", .string, .required)
            .field("description", .string, .required)
            .field("price", .double, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
       try await database.schema("packages").delete()
    }
}