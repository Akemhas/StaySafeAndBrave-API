import Fluent
import struct Foundation.UUID

// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property wrapper.
// It is recommended you write your model with sendability checking on and then suppress the warning
// afterwards with `@unchecked Sendable`.

final class TeamMember: Model, @unchecked Sendable {
    static let schema = "team_members"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name") 
    var name: String

    @Field(key: "role") 
    var role: String
    
    @Field(key: "bio") 
    var bio: String

    @Field(key: "picture_url") 
    var pictureURL: String

    init() { }

    init(id: UUID? = nil, name: String, role: String, bio: String, pictureURL: String) {
        self.id = id
        self.name = name
        self.role = role
        self.bio = bio
        self.pictureURL = pictureURL
    }

    func toDTO() -> TeamMemberDTO {
        .init(
            id: self.id,
            name: self.$name.value ?? "",
            role: self.$role.value,
            bio: self.$bio.value,
            pictureURL: self.$pictureURL.value
        )
    }
}