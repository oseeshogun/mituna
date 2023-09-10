import { onRequest } from 'firebase-functions/v2/https'
import { ControllerRequest } from '../../../core/controllers/methods'
import { RewardService } from '../rewards.service'

export const deleteRewards = onRequest(async (_, __) => {
  ControllerRequest(_, __, {
    method: 'DELETE',
    callback: function ({ decoded, response }) {
      if (!decoded) return response.sendStatus(401)
      const service = new RewardService()
      return service.deleteMany(decoded?.uid)
    },
  })
})
