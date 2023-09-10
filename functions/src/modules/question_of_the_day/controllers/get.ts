import { onRequest } from 'firebase-functions/v2/https'
import { ControllerRequest } from '../../../core/controllers/methods'
import { QuestionOfTheDayService } from '../question_of_the_day.service'

export const getQuestionOfTheDay = onRequest((_, __) => {
  ControllerRequest(_, __, {
    method: 'GET',
    callback: function () {
      const service = new QuestionOfTheDayService()
      return service.get()
    },
  })
})
