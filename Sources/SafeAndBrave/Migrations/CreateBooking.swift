import Fluent

struct CreateBooking: AsyncMigration {
    func prepare(on database: any Database) async throws {
       try await database.schema("bookings")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("mentor_id", .uuid, .required, .references("mentors", "id", onDelete: .cascade))
            .field("date", .string, .required)
            .field("status", .string, .required)
            .field("description", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
       try await database.schema("bookings").delete()
    }
}