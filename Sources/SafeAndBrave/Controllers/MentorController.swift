import Vapor
import Fluent

struct MentorController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let MentorRoutes = routes.grouped("mentors")


        MentorRoutes.get(":mentorID", use: self.index)
        MentorRoutes.post(use: self.create)
        MentorRoutes.put(":userID", use: self.update)
        MentorRoutes.group(":id") { model in
            model.delete(use: delete)
        }
        MentorRoutes.get(use: self.indexAll)
    }

    @Sendable
    func index(req: Request) async throws -> MentorDTO {
        // Fetch the Mentor model with Id from the database and return it as a DTO
        // Fetch a user by ID from the database
        guard let mentor = try await Mentor.find(req.parameters.get("mentorID"), on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        // Return the user as a DTO
        return mentor.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> MentorDTO {
        // Create a new model from the request body and save it to the database
        let mentorDTO = try req.content.decode(MentorDTO.self)
        guard let user = try await User.find(mentorDTO.userID, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        // Ensure userID is unique in the mentor table
        guard try await Mentor.query(on: req.db)
            .filter(\.$user.$id == user.id ?? UUID())
            .first() == nil else {
            throw Abort(.badRequest, reason: "User is already a mentor")
        }
        // Ensure that the role of the user is "mentor"
        guard user.role == "mentor" else {
            throw Abort(.badRequest, reason: "User does not have as role mentor")
        }

        let mentor = Mentor(
            userID: user.id ?? UUID(),
            location: mentorDTO.location ?? "",
            bio: mentorDTO.bio ?? "",
            profile_image: mentorDTO.profile_image ?? "",
            score: mentorDTO.score ?? 0.0,
            languages: mentorDTO.languages ?? [],
            hobbies: mentorDTO.hobbies ?? []
        )

        // Save the mentor to the database
        try await mentor.save(on: req.db)
        // Return the created mentor as a DTO
        return mentor.toDTO()
    }

    @Sendable
    func update(req: Request) async throws -> MentorDTO {
        // Update an existing model in the mentor table using the userID from the request parameters
        let userID = req.parameters.get("userID") ?? ""
        guard let mentor = try await Mentor.query(on: req.db)
            .filter(\.$user.$id == UUID(uuidString: userID) ?? UUID())
            .first() else {
            throw Abort(.notFound, reason: "Mentor not found")
        }
        // Decode the request body into a MentorDTO
        let mentorDTO = try req.content.decode(MentorDTO.self)
        
        // Update the mentor's properties
        mentor.location = mentorDTO.location ?? mentor.location
        mentor.bio = mentorDTO.bio ?? mentor.bio
        mentor.profile_image = mentorDTO.profile_image ?? mentor.profile_image
        mentor.score = mentorDTO.score ?? mentor.score
        mentor.languages = mentorDTO.languages ?? mentor.languages
        mentor.hobbies = mentorDTO.hobbies ?? mentor.hobbies
        
        // Save the updated mentor to the database
        try await mentor.save(on: req.db)
        
        // Return the updated mentor as a DTO
        return mentor.toDTO()
    }


    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        // Delete a model by ID from the database and return a success status
        guard let mentor = try await Mentor.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound, reason: "Mentor not found")
        }
        try await mentor.delete(on: req.db)
        return .noContent
    }

    @Sendable
    func indexAll(req: Request) async throws -> [MentorResponseDTO] {
        // Fetch all mentors from the database and return them as DTOs
        let mentors = try await Mentor.query(on: req.db).all()
        //
        // Convert  each Mentor to MentorResponseDTO
        // seach for user by id to get the name and date of birth
        var response: [MentorResponseDTO] = []
        for mentor in mentors {
            let user = try await User.find(mentor.$user.id, on: req.db)
            response.append(MentorResponseDTO(
                id: mentor.id,
                name: user?.name,
                profile_image: mentor.profile_image,
                score: mentor.score,
                birth_date: user?.birth_date,
                bio: mentor.bio,
                languages: mentor.languages,
                hobbies: mentor.hobbies,
                location: mentor.location
            ))
        }
        return response

    }
}