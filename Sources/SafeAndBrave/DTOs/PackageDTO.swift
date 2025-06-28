import Fluent
import Vapor

struct PackageDTO: Content {
    var id: UUID?
    var mentorID: UUID?
    var title: String?
    var description: String?
    var price: Float?

    init(id: UUID? = nil, mentorID: UUID? = nil, title: String? = nil, description: String? = nil, price: Float? = nil) {
        self.id = id
        self.mentorID = mentorID
        self.title = title
        self.description = description
        self.price = price
    }

    func toModel() -> Package {
        let model = Package()

        model.id = self.id
        if let mentorID = self.mentorID {
            model.$mentor.id = mentorID // Ensure mentor ID is set if mentor is provided
        }
        if let title = self.title {
            model.title = title
        }
        if let description = self.description {
            model.description = description
        }
        if let price = self.price {
            model.price = price
        }
        // Note: The createdAt field is typically set by the database, so we don't set it here.
        // The bookings field is managed by the Package model and is not set here.
        return model
    }
}