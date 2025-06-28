import Fluent
import Vapor

struct TeamMemberDTO: Content {
    var id: UUID?
    var name: String?
    var role: String?
    var bio: String?
    var pictureURL: String?

    init(id: UUID? = nil, name: String?, role: String? = nil, bio: String? = nil, pictureURL: String? = nil) {
        self.id = id
        self.name = name
        self.role = role
        self.bio = bio
        self.pictureURL = pictureURL
    }

    func toModel() -> TeamMember {
        let model = TeamMember()

        model.id = self.id
        if let name = self.name {
            model.name = name
        }
        if let role = self.role {
            model.role = role
        }
        if let bio = self.bio {
            model.bio = bio
        }
        if let pictureURL = self.pictureURL {
            model.pictureURL = pictureURL
        }
        // Note: The createdAt field is typically set by the database, so we don't set it here.
        return model
    }
}