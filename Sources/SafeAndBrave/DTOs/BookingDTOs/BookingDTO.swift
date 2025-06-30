import Fluent
import Vapor

struct BookingDTO: Content {
    var id: UUID?
    var userID: UUID?
    var mentorID: UUID?
    var date: String?
    var status: String?
    var description: String?

    init(id: UUID? = nil, userID: UUID? = nil, mentorID: UUID? = nil, date: String? = nil, status: String? = nil, description: String? = nil) {
        self.id = id
        self.userID = userID
        self.mentorID = mentorID
        self.date = date
        self.status = status
        self.description = description
    }

    func toModel() -> Booking {
        let model = Booking()

        model.id = self.id
        if let userID = self.userID {
            model.$user.id = userID // Ensure user ID is set if user is provided
        }
        if let mentorID = self.mentorID {
            model.$mentor.id = mentorID // Ensure mentor ID is set if mentor is provided
        }
        if let date = self.date {
            model.date = date
        }
        if let status = self.status {
            model.status = status
        }
        if let description = self.description {
            model.description = description
        } else {
            model.description = "" // Default to empty string if not provided
        }
        // Note: The createdAt field is typically set by the database, so we don't set it here.
        // The user and mentor fields are managed by the Booking model and are not set here.
        return model
    }
}