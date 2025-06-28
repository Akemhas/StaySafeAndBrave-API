import Fluent
import Vapor

struct ReportDTO: Content {
    var id: UUID?
    var userID: UUID?
    var text: String?
    var pictureURL: String?

    init(id: UUID? = nil, userID: UUID? = nil, text: String? = nil, pictureURL: String? = nil) {
        self.id = id
        self.userID = userID
        self.text = text
        self.pictureURL = pictureURL
    }

    func toModel() -> Report {
        let model = Report()

        model.id = self.id
        if let userID = self.userID {
            model.$user.id = userID // Ensure user ID is set if user is provided
        }
        if let text = self.text {
            model.text = text
        }
        if let pictureURL = self.pictureURL {
            model.pictureURL = pictureURL
        }
        // Note: The createdAt field is typically set by the database, so we don't set it here.
        // The user field is managed by the Report model and is not set here.
        // The reports field is managed by the User model and is not set here.
        return model
    }
}