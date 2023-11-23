import { onSchedule } from 'firebase-functions/v2/scheduler'
import { QuestionOfTheDayService } from '../question_of_the_day.service'
import { messaging } from '../../../admin'

export const remindQuestionOfTheDay = onSchedule('45 13 * * *', async () => {
  const service = new QuestionOfTheDayService()

  const value = await service.get()

  messaging.sendToTopic('question_of_the_day', {
    notification: {
      title: 'Question du jour',
      body: value?.question,
      color: '#374e86',
    },
    data: {
      type: 'question_of_the_day',
    },
  })
})
