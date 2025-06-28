import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")

          users.post("register", use: self.register)
          users.post("login", use: self.login)
          users.put(":userID", use: self.update)
          users.get(":userID", use: self.index)
          users.group(":userID") { user in
              user.delete(use: self.delete)
          }

          users.get(use: self.listUsers) // <-- THIS maps GET /users to listUsers(req:)
      }

    @Sendable
    func register(req: Request) async throws -> UserDTO {
        let userDTO = try req.content.decode(UserDTO.self)
        guard let email = userDTO.email, !email.isEmpty else {
            throw Abort(.badRequest, reason: "Email is required")
        }
        let hashedPassword = try Bcrypt.hash(userDTO.password ?? "")

        // Check if a user with the same email already exists
        guard try await User.query(on: req.db)
            .filter(\.$email == email)
            .first() == nil else {
            throw Abort(.badRequest, reason: "User with this email already exists")
        }
        // Create a new user model from the request body
        let user = User(
            name: userDTO.name ?? "",
            email: userDTO.email ?? "",
            password: hashedPassword,
            role: userDTO.role ?? "user",
            birth_date: userDTO.birth_date ?? Date().ISO8601Format() // Default to current date if not provided
        )
        

        // Save the user to the database
        try await user.save(on: req.db)
        return user.toDTO()
    }

    @Sendable
    func login(req: Request) async throws -> UserDTO {
        let userDTO = try req.content.decode(UserDTO.self)

        guard let user = try await User.query(on: req.db)
            .filter(\.$email == userDTO.email ?? "")
            .first() else {
            throw Abort(.unauthorized, reason: "Invalid email or password")
        }

        guard let password = userDTO.password, try Bcrypt.verify(password, created: user.password)
        else {
            throw Abort(.unauthorized, reason: "Invalid email or password")
        }

        // TODO: Implement token generation for authenticated users
        // For now, we will just return the user DTO
        
        // If the password is valid, return the user DTO

        return user.toDTO()
    }

    @Sendable
    func index(req: Request) async throws -> UserDTO {
        // Fetch a user by ID from the database
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }
        // Return the user as a DTO
        return user.toDTO()
    }  

    @Sendable
    func update(req: Request) async throws -> UserDTO {
        // Fetch the user by ID
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound, reason: "User not found")
        }

        // Decode the updated user data from the request body
        let updatedUserDTO = try req.content.decode(UserDTO.self)

        // Update the user's properties
        user.name = updatedUserDTO.name ?? user.name
        // check if email is provided and not empty and if it is different from the current email and if it is unique
        if let newEmail = updatedUserDTO.email, !newEmail.isEmpty, newEmail != user.email {
            guard try await User.query(on: req.db)
                .filter(\.$email == newEmail)
                .first() == nil else {
                throw Abort(.badRequest, reason: "User with this email already exists")
            }
        }
        user.email = updatedUserDTO.email ?? user.email
        if let newPassword = updatedUserDTO.password, !newPassword.isEmpty {
            user.password = try Bcrypt.hash(newPassword)
        }
        // TODO should we allow role updates?
        // user.role = updatedUserDTO.role ?? user.role

        // Save the updated user to the database
        try await user.save(on: req.db)

        // Return the updated user as a DTO
        return user.toDTO()
    }  



    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await user.delete(on: req.db)
        return .noContent
    }
    
    @Sendable
    func listUsers(req: Request) async throws -> View {
        let users = try await User.query(on: req.db).all()
        print("Found \(users.count) users in database")
        let userDTOs = users.map { $0.toDTO() }
        print("Converted to \(userDTOs.count) DTOs")

        let context = LeafUserContext(
            users: userDTOs
//            search: req.query[String.self, at: "search"] ?? "",
//            role: req.query[String.self, at: "role"] ?? ""
        )

        return try await req.view.render("users", context)
    }
}

struct LeafUserContext: Encodable {
    let users: [UserDTO]
//    let search: String
//    let role: String
}
