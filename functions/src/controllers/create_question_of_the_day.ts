import { onRequest } from 'firebase-functions/v2/https'
import { functionValidators } from '../validators/validators'
import { body } from 'express-validator'
import { QuestionOfTheDay } from '../models/question_of_the_day'

export const createQuestionOfTheDay = onRequest(async (request, response) => {
  if (request.method !== 'POST') {
    response.sendStatus(405)
    return
  }
  if (request.headers.authorization !== process.env.QUESTION_OF_THE_DAY_KEY) {
    response.sendStatus(401)
    return
  }
  const result = await functionValidators(
    [
      body('questions')
        .isArray()
        .withMessage('Questions must be array')
        .exists()
        .withMessage('Questions must exists')
        .notEmpty()
        .withMessage('Questions must not be empty'),
      body('questions.*.question')
        .isString()
        .withMessage('Question must be a string')
        .notEmpty()
        .withMessage('Question content can not be empty'),
      body('questions.*.date')
        .isString()
        .withMessage('Question date must be a string')
        .notEmpty()
        .withMessage('Question date ne peut pas etre vide')
        .exists()
        .withMessage('Question date is required')
        .matches(/\d\d\/\d\d\/\d\d\d\d/g)
        .withMessage('Question must be in format dd/MM/yyyy'),
      body('questions.*.assertions')
        .isArray()
        .withMessage('Assertions must be an array')
        .notEmpty()
        .withMessage('Assertions must not be empty'),
      body('questions.*.assertions').custom((value) => {
        if (value.length != 4) {
          throw new Error('Assertions must contains only 4 assertions')
        }
        for (const v in value) {
          if (typeof v !== 'string') {
            throw new Error('Assertions must be all strings')
          }
        }
        return true
      }),
      body('questions.*.reponse')
        .isString()
        .withMessage('Response must be a string')
        .exists()
        .withMessage('Response is required')
        .notEmpty()
        .withMessage('Response must not be empty'),
      body('questions.*').custom((value) => {
        const assertions: string[] = value['assertions']
        const response: string = value['reponse']
        if (!assertions.includes(response)) {
          throw new Error('Response must be in assertions')
        }
        return true
      }),
    ],
    request,
  )
  if (!result.valid) {
    response.status(400).json({ errors: result.errors })
    return
  }

  const { questions } = request.body

  QuestionOfTheDay.insertMany(questions)
    .then((value) => {
      response.json(value)
    })
    .catch((error) => {
      response.status(400).json(error)
    })
})
