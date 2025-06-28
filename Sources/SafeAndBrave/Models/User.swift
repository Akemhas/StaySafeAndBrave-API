import Fluent
import Foundation
import struct Foundation.UUID

// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property wrapper.
// It is recommended you write your model with sendability checking on and then suppress the warning
// afterwards with `@unchecked Sendable`.

final class User: Model, @unchecked Sendable {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name") 
    var name: String

    @Field(key: "email") 
    var email: String
    
    @Field(key: "password") 
    var password: String

    @Field(key: "role") 
    var role: String

    @Field(key: "birth_date")
    var birth_date: String?

    @Timestamp(key: "created_at", on: .create) 
    var createdAt: Date?

    @Children(for: \.$user) 
    var bookings: [Booking]

    @Children(for: \.$user) 
    var reports: [Report]

    init() { }

    init(id: UUID? = nil, name: String, email: String, password: String, role: String, birth_date: String?) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.role = role
        self.birth_date = birth_date
    }

    func toDTO() -> UserDTO {
        .init(
            id: self.id,
            name: self.name,
            email: self.email,
            role: self.role,
            birth_date: self.birth_date ?? Date().ISO8601Format()
        )
    }
}
