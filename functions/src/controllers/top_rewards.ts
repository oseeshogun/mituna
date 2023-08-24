import { onRequest } from 'firebase-functions/v2/https'
import { functionValidators } from '../validators/validators'
import { FilterQuery } from 'mongoose'
import { Reward } from '../models/reward'
import { FilterQueries } from '../utils/filter.queries'
import { query } from 'express-validator'
import { authenticatedRequest } from '../validators/authentification'
import { auth } from '../admin'

export const topRewards = onRequest(async (request, response) => {
  const { authenticated, error } = await authenticatedRequest(request, auth)

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

  const { period } = request.query

  const filters: {
    [key: string]: () => FilterQuery<typeof Reward> | undefined
  } = {
    month: FilterQueries.monthTopRewards,
    week: FilterQueries.weekTopRewards,
    all: FilterQueries.allTimeTopRewards,
  }

  const filter = filters[(period as string | undefined) || 'all']

  const data = await Reward.aggregate([
    {
      $match: filter() || {},
    },
    {
      $group: {
        _id: '$uid',
        count: { $sum: { $toInt: '$topaz' } },
      },
    },
    {
      $sort: {
        count: -1,
      },
    },
    {
      $limit: 30,
    },
  ])
  response.json(data)
})
