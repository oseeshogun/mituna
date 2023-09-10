import { FilterQuery } from 'mongoose'
import { FilterQueries } from '../../core/utils/filter.queries'
import { Reward, RewardModel } from './reward.model'
import { Utilities } from '../../core/utils/utils'

export class RewardService {
  create({
    topaz,
    duration = 0,
    uid,
    date,
  }: {
    topaz: number
    duration: number
    uid: string
    date: string | Date | number
  }) {
    return RewardModel.create({
      topaz,
      duration,
      uid,
      createdAt: new Date(date),
    })
  }

  async topRewards(period: 'all' | 'month' | 'week') {
    const filters: {
      [key: string]: () => FilterQuery<typeof Reward> | undefined
    } = {
      month: FilterQueries.monthTopRewards,
      week: FilterQueries.weekTopRewards,
      all: FilterQueries.allTimeTopRewards,
    }

    const filter = filters[(period as string | undefined) || 'all']

    return await RewardModel.aggregate([
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
  }

  async getMine(uid: string, period: 'all' | 'month' | 'week') {
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

    const result = await RewardModel.aggregate([
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

    return { ranked: result.length + 1, score }
  }

  deleteMany(uid: string) {
    return RewardModel.deleteMany({ uid })
  }
}
