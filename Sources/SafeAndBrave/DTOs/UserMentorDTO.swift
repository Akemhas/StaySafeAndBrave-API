import Fluent
import Vapor

struct UserMentorDTO: Content {
    var id: UUID?
    var mentorID: UUID?
    var name: String?
    var email: String?
    var password: String? 
    var role: String?
    var birth_date: String?
    var location: String?
    var bio: String?
    var profile_image: String?
    var score: Float?
    var languages: [String]?
    var hobbies: [String]?

    //from decoder: any Decoder) throws
    init(
        id: UUID? = nil, 
        mentorID: UUID? = nil,
        name: String? = nil, 
        email: String? = nil, 
        password: String? = nil,
        role: String? = nil, 
        birth_date: String? = nil, 
        location: String? = nil, 
        bio: String? = nil, 
        profile_image: String? = nil, 
        score: Float? = nil, 
        languages: [String]? = nil, 
        hobbies: [String]? = nil
    ) {
        self.id = id
        self.mentorID = mentorID
        self.name = name
        self.email = email
        self.password = password
        self.role = role
        self.birth_date = birth_date
        self.location = location
        self.bio = bio
        self.profile_image = profile_image
        self.score = score
        self.languages = languages
        self.hobbies = hobbies
    }
    
        
}

    

