import { onRequest } from 'firebase-functions/v2/https'
import { authenticatedRequest } from '../validators/authentification'
import { functionValidators } from '../validators/validators'
import { query } from 'express-validator'
import { Reward } from '../models/reward'
import { FilterQueries } from '../utils/filter.queries'
import { Utilities } from '../utils/utils'
import { auth } from '../admin'
import { DecodedIdToken } from 'firebase-admin/auth'
import { FilterQuery } from 'mongoose'

export const getMine = onRequest(async (request, response) => {
  if (request.method !== 'GET') {
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

  const validationResult = await functionValidators(
    [query('period').isIn(['all', 'month', 'week']).optional()],
    request,
  )

  if (!validationResult.valid) {
    response.status(400).json({ errors: validationResult.errors })
    return
  }

  const { uid } = decoded as DecodedIdToken

  const { period } = request.query

  const filters: {
    [key: string]: () => FilterQuery<typeof Reward> | undefined
  } = {
    month: FilterQueries.monthTopRewards,
    week: FilterQueries.weekTopRewards,
    all: FilterQueries.allTimeTopRewards,
  }

  const scoreObject: {
    [key: string]: (uid: string) => Promise<number> | undefined
  } = {
    month: Utilities.monthScore,
    week: Utilities.weekScore,
    all: Utilities.allTimeScore,
  }

  const filter = filters[(period as string | undefined) || 'all']

  const scoreFunction = scoreObject[(period as string | undefined) || 'all']

  const score = await scoreFunction(uid)

  const result = await Reward.aggregate([
    {
      $match: {
        uid: { $ne: uid },
        ...filter(),
      },
    },
    {
      $group: {
        _id: '$uid',
        count: { $sum: { $toInt: '$topaz' } },
      },
    },
    {
      $match: {
        count: { $gt: score },
      },
    },
  ])

  response.json({ ranked: result.length + 1, score })
})
