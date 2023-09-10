import { body } from 'express-validator'
import { onRequest } from 'firebase-functions/v2/https'
import { ControllerRequest } from '../../../core/controllers/methods'
import { RewardService } from '../rewards.service'

export const createReward = onRequest(async (_, __) => {
  ControllerRequest(_, __, {
    method: 'POST',
    validators: [
      body('topaz').isNumeric(),
      body('date').isString().isISO8601().withMessage('Iso Date Required'),
      body('duration').isNumeric(),
    ],
    callback: function ({ decoded, response, request }) {
      const { topaz, duration, date } = request.body
      if (!decoded) return response.sendStatus(401)
      const service = new RewardService()
      return service.create({ topaz, duration, date, uid: decoded?.uid })
    },
  })
})
