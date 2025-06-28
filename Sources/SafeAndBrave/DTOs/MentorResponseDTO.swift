import Fluent
import Vapor

struct MentorResponseDTO: Content {
    var id: UUID?
    var name: String?
    var profile_image: String?
    var score: Float?
    var birth_date: String?
    var bio: String?
    var languages: [String]?
    var hobbies: [String]?
    var location: String?

    init(
        id: UUID? = nil,
        name: String? = nil,
        profile_image: String? = nil,
        score: Float? = nil,
        birth_date: String? = nil,
        bio: String? = nil,
        languages: [String]? = nil,
        hobbies: [String]? = nil,
        location: String? = nil
    ) {
        self.id = id
        self.name = name
        self.profile_image = profile_image
        self.score = score
        self.birth_date = birth_date
        self.bio = bio
        self.languages = languages
        self.hobbies = hobbies
        self.location = location
    }

}
