import Vapor
import Fluent

struct ReportController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let ReportRoutes = routes.grouped("reports")

        ReportRoutes.get(use: index)
        ReportRoutes.post(use: create)
        ReportRoutes.group(":id") { model in
            model.get(use: get)
            model.put(use: update)
            model.delete(use: delete)
        }
    }

    @Sendable
    func index(req: Request) async throws -> [ReportDTO] {
        // Fetch all models from the database and return them as DTOs
        let reports = try await Report.query(on: req.db).all()
        return reports.map { $0.toDTO() }
    }

    @Sendable
    func create(req: Request) async throws -> ReportDTO {
        // Create a new model from the request body and save it to the database
        let dto = try req.content.decode(ReportDTO.self)
        let report = Report(
            userID: dto.userID ?? UUID(),
            text: dto.text ?? "",
            pictureURL: dto.pictureURL ?? ""
        )
        try await report.save(on: req.db)
        // Return the created model as a DTO
        return report.toDTO()
    }

    @Sendable
    func get(req: Request) async throws -> ReportDTO {
        // Fetch a single model by ID from the database and return it as a DTO
        guard let idString = req.parameters.get("id"), let id = UUID(uuidString: idString) else {
            throw Abort(.badRequest, reason: "Invalid report ID")
        }
        guard let report = try await Report.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Report not found")
        }
        return report.toDTO()
    }

    @Sendable
    func update(req: Request) async throws -> ReportDTO {
        // Update an existing model with the data from the request body and save it to the database
        guard let idString = req.parameters.get("id"), let id = UUID(uuidString: idString) else {
            throw Abort(.badRequest, reason: "Invalid report ID")
        }
        guard let report = try await Report.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Report not found")
        }
        let dto = try req.content.decode(ReportDTO.self)
        report.text = dto.text ?? report.text
        report.pictureURL = dto.pictureURL ?? report.pictureURL
        try await report.save(on: req.db)
        return report.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> String {
        // Delete a model by ID from the database and return a success status
        guard let idString = req.parameters.get("id"), let id = UUID(uuidString: idString) else {
            throw Abort(.badRequest, reason: "Invalid report ID")
        }
        guard let report = try await Report.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Report not found")
        }
        try await report.delete(on: req.db)
        // Return a success status
        return "Report deleted successfully"
    }
}