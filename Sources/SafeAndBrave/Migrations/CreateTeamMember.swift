import Fluent

struct CreateTeamMember: AsyncMigration {
    func prepare(on database: any Database) async throws {
       try await database.schema("team_members")
            .id()
            .field("name", .string, .required)
            .field("role", .string, .required)
            .field("bio", .string, .required)
            .field("picture_url", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
       try await database.schema("team_members").delete()
    }
}