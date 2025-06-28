import Vapor
import Fluent

struct PackageController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let PackageRoutes = routes.grouped("packages")

        PackageRoutes.get(use: index)
        PackageRoutes.post(use: create)
        PackageRoutes.group(":id") { model in
            model.get(use: get)
            model.put(use: update)
            model.delete(use: delete)
        }
    }

    @Sendable
    func index(req: Request) async throws -> [PackageDTO] {
        // Fetch all models from the database and return them as DTOs
        let packages = try await Package.query(on: req.db).all()
        return packages.map { $0.toDTO() }
    }

    @Sendable
    func create(req: Request) async throws -> PackageDTO {
        // Create a new model from the request body and save it to the database
        let dto = try req.content.decode(PackageDTO.self)
        let package = Package(
            mentorID: dto.mentorID ?? UUID(),
            title: dto.title ?? "",
            description: dto.description ?? "",
            price: dto.price ?? 0.0
        )
        try await package.save(on: req.db)
        // Return the created model as a DTO
        return package.toDTO()
        
    }

    @Sendable
    func get(req: Request) async throws -> PackageDTO {
        // Fetch a single model by ID from the database and return it as a DTO
        guard let idString = req.parameters.get("id"), let id = UUID(uuidString: idString) else {
            throw Abort(.badRequest, reason: "Invalid package ID")
        }
        guard let package = try await Package.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Package not found")
        }
        return package.toDTO()
    }

    @Sendable
    func update(req: Request) async throws -> PackageDTO {
        // Update an existing model with the data from the request body and save it to the database
        guard let idString = req.parameters.get("id"), let id = UUID(uuidString: idString) else {
            throw Abort(.badRequest, reason: "Invalid package ID")
        }
        guard let package = try await Package.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Package not found")
        }
        let dto = try req.content.decode(PackageDTO.self)
        package.title = dto.title ?? package.title
        package.description = dto.description ?? package.description
        package.price = dto.price ?? package.price
        try await package.save(on: req.db)
        // Return the updated model as a DTO
        return package.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> String {
        // Delete a model by ID from the database and return a success status
        guard let idString = req.parameters.get("id"), let id = UUID(uuidString: idString) else {
            throw Abort(.badRequest, reason: "Invalid package ID")
        }
        guard let package = try await Package.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Package not found")
        }
        try await package.delete(on: req.db)
        // Return a success status
        return "Package deleted successfully"
    }
}