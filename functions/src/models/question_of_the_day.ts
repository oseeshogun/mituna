import mongoose from 'mongoose'

const questionOfTheDaySchema = new mongoose.Schema({
  question: String,
  date: {
    type: String,
    unique: true,
  },
  assertions: [String],
  reponse: String,
})

const QuestionOfTheDay = mongoose.model(
  'questions_of_the_days',
  questionOfTheDaySchema,
)

export { questionOfTheDaySchema, QuestionOfTheDay }
