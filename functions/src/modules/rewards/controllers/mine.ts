import { onRequest } from 'firebase-functions/v2/https'
import { ControllerRequest } from '../../../core/controllers/methods'
import { RewardService } from '../rewards.service'
import { query } from 'express-validator'

export const getMine = onRequest(async (_, __) => {
  ControllerRequest(_, __, {
    method: 'GET',
    validators: [query('period').isIn(['all', 'month', 'week']).optional()],
    callback: function ({ decoded, response, request }) {
      const { period } = request.query
      if (!decoded) return response.sendStatus(401)
      const service = new RewardService()
      return service.getMine(decoded?.uid, period as 'all' | 'month' | 'week')
    },
  })
})
