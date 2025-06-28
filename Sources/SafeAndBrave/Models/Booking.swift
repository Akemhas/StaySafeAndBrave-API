import Fluent
import Foundation
import struct Foundation.UUID

// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property wrapper.
// It is recommended you write your model with sendability checking on and then suppress the warning
// afterwards with `@unchecked Sendable`.

final class Booking: Model, @unchecked Sendable {
    static let schema = "bookings"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id") 
    var user: User

    @Parent(key: "mentor_id") 
    var mentor: Mentor

    @Field(key: "date") 
    var date: Date

    @Field(key: "status") 
    var status: String

    @Field(key: "description")
    var description: String

    init() { }

    init(id: UUID? = nil, userID: UUID, mentorID: UUID, date: Date, status: String, description: String) {
        self.id = id
        self.$user.id = userID
        self.$mentor.id = mentorID
        self.date = date
        self.status = status
        self.description = description
    }

    func toDTO() -> BookingDTO {
        .init(
            id: self.id,
            userID: self.$user.id,
            mentorID: self.$mentor.id,
            date: self.$date.value,
            status: self.$status.value,
            description: self.$description.value
        )    
    }

}
