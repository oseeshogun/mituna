import {
  QuestionOfTheDay,
  QuestionOfTheDayModel,
} from './question_of_the_day.model'

export interface IQuestionOfTheDay {
  question: string
  date: string
  assertions: string[]
  reponse: string
}

export class QuestionOfTheDayService {
  create(questions: IQuestionOfTheDay[]) {
    return QuestionOfTheDayModel.insertMany(questions)
  }

  get(lookUpDate?: Date): Promise<QuestionOfTheDay | null> {
    const d = lookUpDate || new Date()
    const date =
      ('0' + d.getDate()).slice(-2) +
      '/' +
      ('0' + (d.getMonth() + 1)).slice(-2) +
      '/' +
      d.getFullYear()
    return QuestionOfTheDayModel.findOne({ date })
  }
}
