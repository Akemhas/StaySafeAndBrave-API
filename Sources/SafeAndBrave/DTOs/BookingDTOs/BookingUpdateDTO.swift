import Fluent
import Vapor

struct BookingUpdateDTO: Content {
    var mentorID: UUID?
    var date: Date?
    var status: String? 

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Decode mentor using its ID
        self.mentorID = try container.decodeIfPresent(UUID.self, forKey: .mentorID)
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
    }
    enum CodingKeys: String, CodingKey {
        case mentorID = "mentor"
        case date
        case status
    }
}