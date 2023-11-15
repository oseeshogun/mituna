import { onRequest } from 'firebase-functions/v2/https'
import { ControllerRequest } from '../../../core/controllers/methods'
import { QuestionOfTheDayService } from '../question_of_the_day.service'

export const getQuestionOfTheDay = onRequest((_, __) => {
  ControllerRequest(_, __, {
    method: 'GET',
    callback: async function () {
      const service = new QuestionOfTheDayService()
      return await service.get()
    },
  })
})
