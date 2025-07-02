import Fluent
import Vapor

struct BookingResponseDTO: Content {
    var id: UUID?
    var userID: UUID?
    var mentorID: UUID?
    var userName: String?
    var mentorName: String?
    var mentorLocation: String?
    var date: String?
    var status: String?
    var description: String?

    init(from booking: Booking, user: User? = nil, mentor: Mentor? = nil, mentorUser: User? = nil) {
        self.id = booking.id
        self.userID = booking.$user.id
        self.mentorID = booking.$mentor.id
        self.userName = user?.name
        self.mentorName = mentorUser?.name
        self.mentorLocation = mentor?.location
        self.date = booking.date
        self.status = booking.status
        self.description = booking.description
    }
}
