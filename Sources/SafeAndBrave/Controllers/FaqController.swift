import Vapor
import Fluent

struct FaqController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let FAQRoutes = routes.grouped("faqs")

        FAQRoutes.get(use: index)
        FAQRoutes.post(use: create)
        FAQRoutes.group(":id") { model in
            model.get(use: get)
            model.put(use: update)
            model.delete(use: delete)
        }
    }

    @Sendable
    func index(req: Request) async throws -> [FaqDTO] {
        // Fetch all models from the database and return them as DTOs
        let faqs = try await FAQ.query(on: req.db).all()
        return faqs.map { $0.toDTO() }
    }

    @Sendable
    func create(req: Request) async throws -> FaqDTO {
        // Create a new model from the request body and save it to the database
        let dto = try req.content.decode(FaqDTO.self)
        let faq = FAQ(
            question: dto.question ?? "",
            answer: dto.answer ?? ""
        )
        try await faq.save(on: req.db)
        // Return the created model as a DTO
        return faq.toDTO()
    }

    @Sendable
    func get(req: Request) async throws -> FaqDTO {
        // Fetch a single model by ID from the database and return it as a DTO
        guard let idString = req.parameters.get("id"), let id = UUID(uuidString: idString) else {
            throw Abort(.badRequest, reason: "Invalid FAQ ID")
        }
        guard let faq = try await FAQ.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "FAQ not found")
        }
        return faq.toDTO()
    }

    @Sendable
    func update(req: Request) async throws -> FaqDTO {
        // Update an existing model with the data from the request body and save it to the database
        guard let idString = req.parameters.get("id"), let id = UUID(uuidString: idString) else {
            throw Abort(.badRequest, reason: "Invalid FAQ ID")
        }
        guard let faq = try await FAQ.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "FAQ not found")
        }
        let dto = try req.content.decode(FaqDTO.self)
        faq.question = dto.question ?? faq.question
        faq.answer = dto.answer ?? faq.answer
        try await faq.save(on: req.db)
        // Return the updated model as a DTO
        return faq.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> String {
        // Delete a model by ID from the database and return a success status
        guard let idString = req.parameters.get("id"), let id = UUID(uuidString: idString) else {
            throw Abort(.badRequest, reason: "Invalid FAQ ID")
        }
        guard let faq = try await FAQ.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "FAQ not found")
        }
        try await faq.delete(on: req.db)
        // Return a success status
        return "FAQ deleted successfully"
    }
}