import { RewardModel } from '../../modules/rewards/reward.model'
import { FilterQueries } from './filter.queries'

export class Utilities {
  static async allTimeScore(uid: string): Promise<number> {
    const result = await RewardModel.aggregate([
      { $match: FilterQueries.userAllTimeRewards(uid) },
      {
        $group: {
          _id: '$uid',
          total: { $sum: { $toInt: '$topaz' } },
        },
      },
    ])
    const score = result.length > 0 ? result[0]?.total : 0
    return score
  }

  static async monthScore(uid: string): Promise<number> {
    const result = await RewardModel.aggregate([
      { $match: FilterQueries.userMonthRewards(uid) },
      {
        $group: {
          _id: '$uid',
          total: { $sum: { $toInt: '$topaz' } },
        },
      },
    ])
    const score = result.length > 0 ? result[0]?.total : 0
    return score
  }

  static async weekScore(uid: string): Promise<number> {
    const result = await RewardModel.aggregate([
      { $match: FilterQueries.userWeekRewards(uid) },
      {
        $group: {
          _id: '$uid',
          total: { $sum: { $toInt: '$topaz' } },
        },
      },
    ])
    const score = result.length > 0 ? result[0]?.total : 0
    return score
  }
}
