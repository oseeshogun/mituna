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

setGlobalOptions({ maxInstances: 10 })

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

export { createReward as createRewardFunction } from './controllers/create_reward'
export { topRewards as topRewardsFunction } from './controllers/top_rewards'
export { getMine as getMineFunction } from './controllers/get_mine'
export { getQuestionOfTheDay as getQuestionOfTheDayFunction } from './controllers/get_question_of_the_day'
export { createQuestionOfTheDay as createQuestionOfTheDayFunction } from './controllers/create_question_of_the_day'
