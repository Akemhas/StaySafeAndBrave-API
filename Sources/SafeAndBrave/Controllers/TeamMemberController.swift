import Vapor
import Fluent

struct TeamMemberController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let TeamMemberRoutes = routes.grouped("teamMembers")

        TeamMemberRoutes.get(use: self.index)
        TeamMemberRoutes.post(use: self.create)
        TeamMemberRoutes.group(":id") { model in
            model.get(use: self.get)
            model.put(use: self.update)
            model.delete(use: self.delete)
        }
    }

    @Sendable
    func index(req: Request) async throws -> [TeamMemberDTO] {
        // fetch all TeamMembers from the database and return them as DTOs
        let teamMembers = try await TeamMember.query(on: req.db).all()
        return teamMembers.map { $0.toDTO() }
    }

    @Sendable
    func create(req: Request) async throws -> TeamMemberDTO {
        // Create a new TeamMember model from the request body and save it to the database
        let dto = try req.content.decode(TeamMemberDTO.self)
        let teamMember = TeamMember(
            name: dto.name ?? "",
            role: dto.role ?? "",
            bio: dto.bio ?? "",
            pictureURL: dto.pictureURL ?? ""
        )
        try await teamMember.save(on: req.db)
        // Return the created TeamMember as a DTO
        return teamMember.toDTO()
    }

    @Sendable
    func get(req: Request) async throws -> TeamMemberDTO {
        // Fetch a single TeamMember by ID from the database and return it as a DTO
        guard let idString = req.parameters.get("id"), let id = UUID(uuidString: idString) else {
            throw Abort(.badRequest, reason: "Invalid team member ID")
        }
        guard let teamMember = try await TeamMember.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Team member not found")
        }
        return teamMember.toDTO()
    }

    @Sendable
    func update(req: Request) async throws -> TeamMemberDTO {
        // Update a TeamMember model by ID from the request body and save it to the database
        guard let idString = req.parameters.get("id"), let id = UUID(uuidString: idString) else {
            throw Abort(.badRequest, reason: "Invalid team member ID")
        }
        guard let teamMember = try await TeamMember.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Team member not found")
        }
        let dto = try req.content.decode(TeamMemberDTO.self)
        teamMember.name = dto.name ?? teamMember.name
        teamMember.role = dto.role ?? teamMember.role
        teamMember.bio = dto.bio ?? teamMember.bio
        teamMember.pictureURL = dto.pictureURL ?? teamMember.pictureURL
        try await teamMember.save(on: req.db)
        // Return the updated TeamMember as a DTO
        return teamMember.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> String {
        // Delete a TeamMember model by ID from the database
        guard let idString = req.parameters.get("id"), let id = UUID(uuidString: idString) else {
            throw Abort(.badRequest, reason: "Invalid team member ID")
        }
        guard let teamMember = try await TeamMember.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Team member not found")
        }
        try await teamMember.delete(on: req.db)
        // Return a success status
        return "Team member deleted successfully"
    }
}