/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
import * as dotenv from 'dotenv'

import { setGlobalOptions } from 'firebase-functions/v2'
import * as logger from 'firebase-functions/logger'
import mongoose from 'mongoose'

setGlobalOptions({ maxInstances: 10, region: 'europe-west2' })

dotenv.config()

const connectionClient = async (mongoUri: string) => {
  await mongoose
    .connect(mongoUri)
    .then(() => logger.info('Mongo connected'))
    .catch((err) =>
      logger.error(`Mongo db error for uri ${mongoUri} :  ${err}`),
    )
}

connectionClient(
  `mongodb+srv://${process.env.MONGO_USER}:${process.env.MONGO_PASSWORD}@${process.env.MONGO_HOST}/${process.env.MONGO_DB}?retryWrites=true&w=majority`,
)

export { createReward as createRewardFunction } from './modules/rewards/controllers/create'
export { deleteRewards as deleteRewardsFunctions } from './modules/rewards/controllers/delete'
export { topRewards as topRewardsFunction } from './modules/rewards/controllers/top'
export { getMine as getMineFunction } from './modules/rewards/controllers/mine'
export { getQuestionOfTheDay as getQuestionOfTheDayFunction } from './modules/question_of_the_day/controllers/get'
export { createQuestionOfTheDay as createQuestionOfTheDayFunction } from './modules/question_of_the_day/controllers/create'
export { remindQuestionOfTheDay as remindQuestionOfTheDayFunction } from './modules/question_of_the_day/jobs/remind'
