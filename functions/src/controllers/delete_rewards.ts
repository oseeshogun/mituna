import { Reward } from '../models/reward'
import { authenticatedRequest } from '../validators/authentification'
import { auth } from '../admin'
import { onRequest } from 'firebase-functions/v2/https'

export const deleteRewards = onRequest(async (request, response) => {
  if (request.method !== 'DELETE') {
    response.sendStatus(405)
    return
  }
  const { authenticated, error, decoded } = await authenticatedRequest(
    request,
    auth,
  )

  if (!authenticated) {
    response.status(401).json({ error })
    return
  }

  const obj = await Reward.deleteMany({
    uid: decoded?.uid,
  })
  response.json(obj)
})
