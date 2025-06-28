import Fluent
import struct Foundation.UUID

// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property wrapper.
// It is recommended you write your model with sendability checking on and then suppress the warning
// afterwards with `@unchecked Sendable`.

final class Mentor: Model, @unchecked Sendable {
    static let schema = "mentors"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id") 
    var user: User

    @Field(key: "location") 
    var location: String

    @Field(key: "bio") 
    var bio: String

    @Field(key: "profile_image") 
    var profile_image: String

    @Field(key: "score") 
    var score: Float

    @Field(key: "languages")
    var languages: [String]

    @Field(key: "hobbies")
    var hobbies: [String]

    @Children(for: \.$mentor) 
    var packages: [Package]

    @Children(for: \.$mentor)
    var bookings: [Booking]

    init() { }

    init(id: UUID? = nil, userID: UUID, location: String, bio: String, profile_image: String, score: Float = 0.0, 
        languages: [String] = [], hobbies: [String] = []) {
        self.id = id
        self.$user.id = userID
        self.location = location
        self.bio = bio
        self.profile_image = profile_image
        self.score = score
        self.languages = languages
        self.hobbies = hobbies
    }

    func toDTO() -> MentorDTO {
        .init(
            id: self.id,
            userID: self.$user.id,
            location: self.$location.value,
            bio: self.$bio.value,
            profile_image: self.$profile_image.value,
            score: self.$score.value,
            languages: self.$languages.value,
            hobbies: self.$hobbies.value)    
    }

    func MentorResponseDTO() -> MentorDTO {
        .init(
            id: self.id,
            userID: self.$user.id,
            location: self.$location.value,
            bio: self.$bio.value,
            profile_image: self.$profile_image.value,
            score: self.$score.value,
            languages: self.$languages.value,
            hobbies: self.$hobbies.value
        )
    }
}