/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import { setGlobalOptions } from 'firebase-functions/v2'
import { onRequest } from 'firebase-functions/v2/https'
import * as logger from 'firebase-functions/logger'
import { body /*  , query */ } from 'express-validator'
import mongoose /*  , { FilterQuery } */ from 'mongoose'
import { functionValidators } from './validators/validators'
import { Reward } from './models/reward'
import { authenticatedRequest } from './validators/authentification'
// import { FilterQueries } from './utils/filter.queries'
// import { Utilities } from './utils/utils'
// import { DecodedIdToken } from 'firebase-admin/auth'

setGlobalOptions({ maxInstances: 5 })
// Start writing functions
// https://firebase.google.com/docs/functions/typescript

const connectionClient = async (mongoUri: string) => {
  await mongoose
    .connect(mongoUri)
    .then(() => logger.info('Mongo connected'))
    .catch((err) =>
      logger.error(`Mongo db error for uri ${mongoUri} :  ${err}`),
    )
}

// export const topRewards = onRequest(async (request, response) => {
//   const validationResult = await functionValidators(
//     [query('period').isIn(['all', 'month', 'week']).optional()],
//     request,
//   )

//   if (!validationResult.valid) {
//     response.status(400).json({ errors: validationResult.errors })
//     return
//   }

//   const { period } = request.query

//   await connectionClient(
//     `mongodb+srv://${process.env.MONGO_USER}:${process.env.MONGO_PASSWORD}@${process.env.MONGO_HOST}/${process.env.MONGO_DB}?retryWrites=true&w=majority`,
//   )

//   const filters: {
//     [key: string]: () => FilterQuery<typeof Reward> | undefined
//   } = {
//     month: FilterQueries.monthTopRewards,
//     week: FilterQueries.weekTopRewards,
//     all: FilterQueries.allTimeTopRewards,
//   }

//   const filter = filters[(period as string | undefined) || 'all']

//   const data = await Reward.aggregate([
//     {
//       $match: filter() || {},
//     },
//     {
//       $group: {
//         _id: '$uid',
//         count: { $sum: { $toInt: '$topaz' } },
//       },
//     },
//     {
//       $sort: {
//         count: -1,
//       },
//     },
//     {
//       $limit: 30,
//     },
//   ])
//   response.json(data)
// })

// export const getMine = onRequest(async (request, response) => {
//   const { authenticated, error, decoded } = await authenticatedRequest(request)

//   if (!authenticated) {
//     response.status(401).json({ error })
//     return
//   }

//   const validationResult = await functionValidators(
//     [query('period').isIn(['all', 'month', 'week']).optional()],
//     request,
//   )

//   if (!validationResult.valid) {
//     response.status(400).json({ errors: validationResult.errors })
//     return
//   }

//   const { uid } = decoded as DecodedIdToken

//   const { period } = request.query

//   await connectionClient(
//     `mongodb+srv://${process.env.MONGO_USER}:${process.env.MONGO_PASSWORD}@${process.env.MONGO_HOST}/${process.env.MONGO_DB}?retryWrites=true&w=majority`,
//   )

//   const filters: {
//     [key: string]: () => FilterQuery<typeof Reward> | undefined
//   } = {
//     month: FilterQueries.monthTopRewards,
//     week: FilterQueries.weekTopRewards,
//     all: FilterQueries.allTimeTopRewards,
//   }

//   const scoreObject: {
//     [key: string]: (uid: string) => Promise<number> | undefined
//   } = {
//     month: Utilities.monthScore,
//     week: Utilities.weekScore,
//     all: Utilities.allTimeScore,
//   }

//   const filter = filters[(period as string | undefined) || 'all']

//   const scoreFunction = scoreObject[(period as string | undefined) || 'all']

//   const score = await scoreFunction(uid)

//   const result = await Reward.aggregate([
//     {
//       $match: {
//         uid: { $ne: uid },
//         ...filter(),
//       },
//     },
//     {
//       $group: {
//         _id: '$uid',
//         count: { $sum: { $toInt: '$topaz' } },
//       },
//     },
//     {
//       $match: {
//         count: { $gt: score },
//       },
//     },
//   ])

//   response.json({ ranked: result.length + 1, score })
// })

export const createReward = onRequest(async (request, response) => {
  const { authenticated, error, decoded } = await authenticatedRequest(request)

  if (!authenticated) {
    response.status(401).json({ error })
    return
  }

  const result = await functionValidators(
    [
      body('topaz').isNumeric(),
      body('date').isDate(),
      body('duration').isNumeric(),
    ],
    request,
  )

  if (!result.valid) {
    response.status(400).json({ errors: result.errors })
    return
  }

  const { topaz, duration, date } = request.body

  await connectionClient(
    `mongodb+srv://${process.env.MONGO_USER}:${process.env.MONGO_PASSWORD}@${process.env.MONGO_HOST}/${process.env.MONGO_DB}?retryWrites=true&w=majority`,
  )
  const obj = await Reward.create({
    topaz,
    duration,
    uid: decoded?.uid,
    createdAt: new Date(date),
  })
  response.json(obj)
})
