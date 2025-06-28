import Fluent
import Vapor

struct UserDTO: Content {
    var id: UUID?
    var name: String?
    var email: String?
    var password: String?
    var role: String?
    var birth_date: String?

    init(id: UUID? = nil, name: String?, email: String? = nil, password: String? = nil, role: String? = nil, birth_date: String? = nil) {
        
        //let container = try decoder.container(keyedBy: CodingKeys.self)
        // Decode user and mentor using their IDs
        
        
        //self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.role = role
        self.birth_date = birth_date
    }

    /*func toModel() -> User {
        let model = User()

        model.id = self.id
        if let name = self.name {
            model.name = name
        }
        if let email = self.email {
            model.email = email
        }
        if let password = self.password {
            model.password = password
        }
        if let role = self.role {
            model.role = role
        }
        if let birth_date = self.birth_date {
            model.birth_date = birth_date
        } else {
            model.birth_date = Date() // Default to current date if not provided
        }
        // Note: The createdAt field is typically set by the database, so we don't set it here.
        // The bookings and reports fields are managed by the User model and are not set here.
        return model
    }*/
}
