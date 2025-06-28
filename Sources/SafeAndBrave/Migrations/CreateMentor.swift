import Fluent

struct CreateMentor: AsyncMigration {
    func prepare(on database: any Database) async throws {
       try await database.schema("mentors")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("location", .string, .required)
            .field("bio", .string, .required)
            .field("profile_image", .string, .required)
            .field("score", .float, .required)
            .field("languages", .array(of: .string), .required)
            .field("hobbies", .array(of: .string), .required)
            .create()
    }

    func revert(on database: any Database) async throws {
       try await database.schema("mentors").delete()
    }
}