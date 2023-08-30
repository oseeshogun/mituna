import { body } from 'express-validator'
import { Reward } from '../models/reward'
import { functionValidators } from '../validators/validators'
import { authenticatedRequest } from '../validators/authentification'
import { auth } from '../admin'
import { onRequest } from 'firebase-functions/v2/https'

export const createReward = onRequest(async (request, response) => {
  if (request.method !== 'POST') {
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

  const result = await functionValidators(
    [
      body('topaz').isNumeric(),
      body('date').isString().isISO8601().withMessage('Iso Date Required'),
      body('duration').isNumeric(),
    ],
    request,
  )

  if (!result.valid) {
    response.status(400).json({ errors: result.errors })
    return
  }

  const { topaz, duration, date } = request.body

  const obj = await Reward.create({
    topaz,
    duration,
    uid: decoded?.uid,
    createdAt: new Date(date),
  })
  response.status(201).json(obj)
})
