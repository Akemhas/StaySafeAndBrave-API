import Fluent
import struct Foundation.UUID

// Property wrappers interact poorly with `Sendable` checking, causing a warning for the `@ID` property wrapper.
// It is recommended you write your model with sendability checking on and then suppress the warning
// afterwards with `@unchecked Sendable`.

final class FAQ: Model, @unchecked Sendable {
    static let schema = "faqs"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "question") 
    var question: String

    @Field(key: "answer") 
    var answer: String

    init() { }

    init(id: UUID? = nil, question: String, answer: String) {
        self.id = id
        self.question = question
        self.answer = answer
    }

    func toDTO() -> FaqDTO {
        .init(
            id: self.id,
            question: self.$question.value,
            answer: self.$answer.value
        )
    }
}