import Fluent

struct CreateFAQ: AsyncMigration {
    func prepare(on database: any Database) async throws {
       try await database.schema("faqs")
            .id()
            .field("question", .string, .required)
            .field("answer", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
       try await database.schema("faqs").delete()
    }
}