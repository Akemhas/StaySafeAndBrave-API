import Fluent
import Vapor

struct MentorDTO: Content {
    var id: UUID?
    var userID: UUID?
    var location: String?
    var bio: String?
    var profile_image: String?
    var score: Float?
    var languages: [String]?
    var hobbies: [String]?

    //from decoder: any Decoder) throws
    init(id: UUID? = nil, userID: UUID? = nil, location: String? = nil, bio: String? = nil, profile_image: String? = nil, score: Float? = nil, languages: [String]? = nil, hobbies: [String]? = nil) {
        self.id = id
        self.userID = userID
        self.location = location
        self.bio = bio
        self.profile_image = profile_image
        self.score = score
        self.languages = languages
        self.hobbies = hobbies
    }

    func toModel() -> Mentor {
        let model = Mentor()

        model.id = self.id
        if let userID = self.userID {
            model.$user.id = userID  // Ensure user ID is set if user is provided
        }
        if let location = self.location {
            model.location = location
        }
        if let bio = self.bio {
            model.bio = bio
        }
        if let profile_image = self.profile_image {
            model.profile_image = profile_image
        }
        if let score = self.score {
            model.score = score
        }
        if let languages = self.languages {
            model.languages = languages
        } else {
            model.languages = []
        }
        if let hobbies = self.hobbies {
            model.hobbies = hobbies
        } else {
            model.hobbies = []
        }
        // Note: The packages and bookings fields are managed by the Mentor model and are not set here.
        // The createdAt field is typically set by the database, so we don't set it here.
        return model
    }
}
