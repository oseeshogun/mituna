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
    callback: async function ({ decoded, response, request }) {
      const { topaz, duration, date } = request.body
      if (!decoded) return response.sendStatus(401)
      const service = new RewardService()

      const reward = await service.getRewardByDate({
        date,
        uid: decoded?.uid,
      })

      if (reward) {
        return response.sendStatus(409)
      }

      return service.create({ topaz, duration, date, uid: decoded?.uid })
    },
  })
})
