import Fluent
import Vapor

struct FaqDTO: Content {
    var id: UUID?
    var question: String?
    var answer: String?

    init(id: UUID? = nil, question: String? = nil, answer: String? = nil) {
        self.id = id
        self.question = question
        self.answer = answer
    }

    func toModel() -> FAQ {
        let model = FAQ()

        model.id = self.id
        if let question = self.question {
            model.question = question
        }
        if let answer = self.answer {
            model.answer = answer
        }
        return model
    }
}