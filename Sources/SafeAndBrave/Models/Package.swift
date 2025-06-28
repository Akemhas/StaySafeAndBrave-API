import Fluent
import struct Foundation.UUID

// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property wrapper.
// It is recommended you write your model with sendability checking on and then suppress the warning
// afterwards with `@unchecked Sendable`.

final class Package: Model, @unchecked Sendable {
    static let schema = "packages"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "mentor_id") 
    var mentor: Mentor

    @Field(key: "title") 
    var title: String

    @Field(key: "description") 
    var description: String

    @Field(key: "price") 
    var price: Float

    init() { }

    init(id: UUID? = nil, mentorID: UUID, title: String, description: String, price: Float) {
        self.id = id
        self.$mentor.id = mentorID
        self.title = title
        self.description = description
        self.price = price
    }

    func toDTO() -> PackageDTO {
        .init(
            id: self.id,
            mentorID: self.$mentor.id,
            title: self.$title.value,
            description: self.$description.value,
            price: self.$price.value
        )
    }
}