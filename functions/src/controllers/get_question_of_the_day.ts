import { onRequest } from 'firebase-functions/v2/https'
import { authenticatedRequest } from '../validators/authentification'
import { auth } from '../admin'
import { QuestionOfTheDay } from '../models/question_of_the_day'

export const getQuestionOfTheDay = onRequest(async (request, response) => {
  if (request.method !== 'GET') {
    response.sendStatus(405)
    return
  }
  const { authenticated, error } = await authenticatedRequest(request, auth)

  if (!authenticated) {
    response.status(401).json({ error })
    return
  }

  const d = new Date()

  const date =
    ('0' + d.getDate()).slice(-2) +
    '/' +
    ('0' + (d.getMonth() + 1)).slice(-2) +
    '/' +
    d.getFullYear()

  QuestionOfTheDay.findOne({ date })
    .then((value) => {
      response.json(value)
    })
    .catch((error) => {
      response.status(400).json(error)
    })
})
