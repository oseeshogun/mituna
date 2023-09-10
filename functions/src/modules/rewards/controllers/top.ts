import { onRequest } from 'firebase-functions/v2/https'
import { ControllerRequest } from '../../../core/controllers/methods'
import { RewardService } from '../rewards.service'
import { query } from 'express-validator'

export const topRewards = onRequest(async (_, __) => {
  ControllerRequest(_, __, {
    method: 'GET',
    validators: [query('period').isIn(['all', 'month', 'week']).optional()],
    callback: function ({ request }) {
      const { period } = request.query
      const service = new RewardService()
      return service.topRewards(period as 'all' | 'month' | 'week')
    },
  })
})
