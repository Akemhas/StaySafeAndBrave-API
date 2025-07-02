import Vapor
import Fluent

struct BookingController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let BookingRoutes = routes.grouped("bookings")

        BookingRoutes.post(use: self.create)
        
        BookingRoutes.get("user", ":userID", use: self.index)
        BookingRoutes.get("mentor", ":mentorID", use: self.indexForMentor)
        
        BookingRoutes.group(":id") { model in
            model.put(use: self.update)
            model.delete(use: self.delete)
        }
    }

    @Sendable
    func create(req: Request) async throws -> BookingDTO {
        // Create a Booking model from the request body and save it to the database
        let dto = try req.content.decode(BookingCreateDTO.self)

        guard let user = try await User.find(dto.userID, on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        // check if the user has the role of "user"
        guard user.role == "user" else {
            throw Abort(.badRequest, reason: "User is a mentor, not a user")
        }
        // Ensure that the mentor exists and the user is a mentor
        guard let mentor = try await Mentor.find(dto.mentorID, on: req.db) else {
            throw Abort(.notFound, reason: "Mentor not found")
        }
        let booking = Booking(
            userID: user.id ?? UUID(),
            mentorID: mentor.id ?? UUID(),
            date: dto.date ?? "29/06/2025",
            status: dto.status ?? "pending",
            description: dto.description ?? ""
        )
        // Save the booking to the database
        try await booking.save(on: req.db)
        // Return the created booking as a DTO
        return booking.toDTO()
    }

    @Sendable
        func index(req: Request) async throws -> [BookingResponseDTO] {
            guard let userID = req.parameters.get("userID"), let id = UUID(uuidString: userID) else {
                throw Abort(.badRequest, reason: "Invalid user ID")
            }
            guard let user = try await User.find(id, on: req.db) else {
                throw Abort(.notFound, reason: "User not found")
            }
            
            // Single query with joins to get all data at once
            let bookings = try await Booking.query(on: req.db)
                .filter(\.$user.$id == user.id ?? UUID())
                .with(\.$mentor) {
                    $0.with(\.$user) // This loads the mentor's user data
                }
                .all()
            
            // Convert to response DTOs
            return bookings.map { booking in
                BookingResponseDTO(
                    from: booking,
                    user: user,
                    mentor: booking.mentor,
                    mentorUser: booking.mentor.user
                )
            }
        }

        @Sendable
        func indexForMentor(req: Request) async throws -> [BookingResponseDTO] {
            guard let mentorID = req.parameters.get("mentorID"), let id = UUID(uuidString: mentorID) else {
                throw Abort(.badRequest, reason: "Invalid mentor ID")
            }
            guard let mentor = try await Mentor.find(id, on: req.db) else {
                throw Abort(.notFound, reason: "Mentor not found")
            }
            
            // Single query with joins to get all data at once
            let bookings = try await Booking.query(on: req.db)
                .filter(\.$mentor.$id == mentor.id ?? UUID())
                .with(\.$user) // Load booking user data
                .with(\.$mentor) {
                    $0.with(\.$user) // Load mentor user data
                }
                .all()
            
            // Convert to response DTOs
            return bookings.map { booking in
                BookingResponseDTO(
                    from: booking,
                    user: booking.user,
                    mentor: booking.mentor,
                    mentorUser: booking.mentor.user
                )
            }
        }
    @Sendable
    func update(req: Request) async throws -> BookingDTO {
        // Update an existing Booking model in the database using the request body
        let dto = try req.content.decode(BookingUpdateDTO.self)

        guard let bookingID = req.parameters.get("id"), let id = UUID(uuidString: bookingID) else {
            throw Abort(.badRequest, reason: "Invalid booking ID")
        }
        guard let booking = try await Booking.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Booking not found")
        }
        // Update the booking's properties
        if let mentorID = dto.mentorID {
            guard let mentor = try await Mentor.find(mentorID, on: req.db) else {
                throw Abort(.notFound, reason: "Mentor not found")
            }
            booking.$mentor.id = mentor.id ?? UUID()
        }
        if let date = dto.date {
            booking.date = date
        }
        if let status = dto.status {
            booking.status = status
        }
        if let description = dto.description {
            booking.description = description
        }
        // Save the updated booking to the database
        try await booking.save(on: req.db)
        // Return the updated booking as a DTO
        return booking.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> String {
        // Delete a model by ID from the database and return a success status
        guard let bookingID = req.parameters.get("id"), let id = UUID(uuidString: bookingID) else {
            throw Abort(.badRequest, reason: "Invalid booking ID")
        }
        guard let booking = try await Booking.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Booking not found")
        }
        try await booking.delete(on: req.db)
        return "Booking deleted successfully"
    }
}
