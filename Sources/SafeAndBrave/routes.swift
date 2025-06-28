import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Safe And Brave"])
    }

    app.get("hello") { req async throws in
        try await req.view.render("hello")
    }

    app.get("health") { req async throws in
        try await req.view.render("health")
    }

    try app.register(collection: TodoController())
    try app.register(collection: UserController())
    try app.register(collection: MentorController())
    try app.register(collection: BookingController())
    try app.register(collection: TeamMemberController())
    try app.register(collection: FaqController())
    try app.register(collection: ReportController())
}
