import { onRequest } from 'firebase-functions/v2/https'
import { ControllerRequest } from '../../../core/controllers/methods'
import { body } from 'express-validator'
import { QuestionOfTheDayService } from '../question_of_the_day.service'
import { QuestionCategory } from '../question_of_the_day.model'

/**
* POST /question-of-the-day
* @param {Array} questions
* @param {string} questions[].question
* @param {string} questions[].category
* @param {string} questions[].date
* @param {Array} questions[].assertions
* @param {string} questions[].reponse
* @return {Object}

Example:

{
  "questions": [
    {
      "question": "Quelle est la montagne la plus haute d'Afrique, située en Tanzanie ?",
      "date": "15/11/2023",
      "category": "geography",
      "assertions": [
      "Mont Everest",
      "Mont Kilimandjaro",
      "Mont Fuji",
      "Mont McKinley"
      ],
      "reponse": "Mont Kilimandjaro"
    }
  ]
}
*/
export const createQuestionOfTheDay = onRequest((_, __) => {
  ControllerRequest(_, __, {
    method: 'POST',
    authenticated: false,
    validators: [
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
      body('questions.*.category')
        .isString()
        .withMessage('Question category must be a string')
        .notEmpty()
        .withMessage('Question category can not be empty')
        .custom((category) => {
          return Object.values(QuestionCategory).includes(category)
        })
        .withMessage('Question category doesn\'t exist'),
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
    callback: function ({ request, response }) {
      if (
        request.headers['question-of-the-day-key'] !==
        process.env.QUESTION_OF_THE_DAY_KEY
      ) {
        response.sendStatus(401)
        return
      }
      const { questions } = request.body
      const service = new QuestionOfTheDayService()
      return service.create(questions)
    },
  })
})
