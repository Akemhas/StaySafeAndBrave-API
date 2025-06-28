import Fluent
import Vapor

struct BookingResponseDTO: Content {
    var id: UUID?
    var userID: UUID?
    var mentorID: UUID?
    var date: Date?
    var status: String?

    init(from booking: Booking) {
        self.id = booking.id
        self.userID = booking.$user.id
        self.mentorID = booking.$mentor.id
        self.date = booking.date
        self.status = booking.status
    }
}