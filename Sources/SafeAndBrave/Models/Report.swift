import Fluent
import Foundation
import struct Foundation.UUID

// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property wrapper.
// It is recommended you write your model with sendability checking on and then suppress the warning
// afterwards with `@unchecked Sendable`.

final class Report: Model, @unchecked Sendable {
    static let schema = "reports"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id") 
    var user: User

    @Field(key: "text") 
    var text: String

    @Field(key: "picture_url") 
    var pictureURL: String

    @Timestamp(key: "created_at", on: .create) 
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, userID: UUID, text: String, pictureURL: String) {
        self.id = id
        self.$user.id = userID
        self.text = text
        self.pictureURL = pictureURL
    }

    func toDTO() -> ReportDTO {
        .init(
            id: self.id,
            userID: self.$user.id,
            text: self.$text.value,
            pictureURL: self.$pictureURL.value
        )
    }
}
