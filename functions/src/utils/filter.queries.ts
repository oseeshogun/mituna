import { FilterQuery } from 'mongoose'
import { CronDateUtils } from './cron.date'
import { Reward } from '../models/reward'

export class FilterQueries {
  static allTimeTopRewards = (): FilterQuery<typeof Reward> => {
    return {}
  }

  static monthTopRewards = (): FilterQuery<typeof Reward> => {
    const greaterDate = CronDateUtils.getMonthGreaterDate()
    const lowerDate = CronDateUtils.getMonthLowerDate()
    return {
      createdAt: {
        $gte: lowerDate,
        $lte: greaterDate,
      },
    }
  }

  static weekTopRewards = (): FilterQuery<typeof Reward> => {
    const greaterDate = CronDateUtils.getWeekGreaterDate()
    const lowerDate = CronDateUtils.getWeekLowerDate()
    return {
      createdAt: {
        $gte: lowerDate,
        $lte: greaterDate,
      },
    }
  }

  static userAllTimeRewards = (uid: string): FilterQuery<typeof Reward> => {
    return { uid }
  }

  static userMonthRewards = (uid: string): FilterQuery<typeof Reward> => {
    const greaterDate = CronDateUtils.getMonthGreaterDate()
    const lowerDate = CronDateUtils.getMonthLowerDate()

    return {
      uid,
      createdAt: {
        $gte: lowerDate,
        $lte: greaterDate,
      },
    }
  }

  static userWeekRewards = (uid: string): FilterQuery<typeof Reward> => {
    const greaterDate = CronDateUtils.getWeekGreaterDate()
    const lowerDate = CronDateUtils.getWeekLowerDate()

    return {
      uid,
      createdAt: {
        $gte: lowerDate,
        $lte: greaterDate,
      },
    }
  }
}
