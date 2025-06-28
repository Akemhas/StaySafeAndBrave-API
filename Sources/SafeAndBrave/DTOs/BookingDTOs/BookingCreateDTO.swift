import Fluent
import Vapor

struct BookingCreateDTO: Content {
    var userID: UUID
    var mentorID: UUID
    var date: Date?
    var status: String?
    var description: String?

    // Custom decoder to support "dd/MM/yyyy" date format
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Decode user and mentor using their IDs        
        self.userID = try container.decode(UUID.self, forKey: .userID)
        self.mentorID = try container.decode(UUID.self, forKey: .mentorID)
        // Decode date with a custom format
        if let dateString = try? container.decode(String.self, forKey: .date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            if let date = dateFormatter.date(from: dateString) {
                self.date = date
            } else {
                // throw an error
                throw DecodingError.dataCorruptedError(forKey: .date, in: container, 
                debugDescription: "Invalid date format. Expected format is dd/MM/yyyy.")
            }
        } else {
            // throw an error if date is not provided
            throw DecodingError.dataCorruptedError(forKey: .date, in: container,
            debugDescription: "Date is required but not provided.")
        }
        // Decode status, defaulting to "pending" if not provided
        self.status = try container.decodeIfPresent(String.self, forKey: .status) ?? "pending"

        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""

    }
    enum CodingKeys: String, CodingKey {
        case userID = "user"
        case mentorID = "mentor"
        case date
        case status
        case description
    }
    
}