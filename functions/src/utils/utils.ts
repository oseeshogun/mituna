// import { Reward } from '../models/reward'
// import { FilterQueries } from './filter.queries'

// export class Utilities {
//   static monthScore: (uid: string) => Promise<number> | undefined
//   static weekScore: (uid: string) => Promise<number> | undefined
//   static allTimeScore: (uid: string) => Promise<number> | undefined
//   async allTimeScore(uid: string): Promise<number> {
//     const result = await Reward.aggregate([
//       { $match: FilterQueries.userAllTimeRewards(uid) },
//       {
//         $group: {
//           _id: '$uid',
//           total: { $sum: { $toInt: '$topaz' } },
//         },
//       },
//     ])
//     const score = result.length > 0 ? result[0]?.total : 0
//     return score
//   }

//   async monthScore(uid: string): Promise<number> {
//     const result = await Reward.aggregate([
//       { $match: FilterQueries.userMonthRewards(uid) },
//       {
//         $group: {
//           _id: '$uid',
//           total: { $sum: { $toInt: '$topaz' } },
//         },
//       },
//     ])
//     const score = result.length > 0 ? result[0]?.total : 0
//     return score
//   }

//   async weekScore(uid: string): Promise<number> {
//     const result = await Reward.aggregate([
//       { $match: FilterQueries.userWeekRewards(uid) },
//       {
//         $group: {
//           _id: '$uid',
//           total: { $sum: { $toInt: '$topaz' } },
//         },
//       },
//     ])
//     const score = result.length > 0 ? result[0]?.total : 0
//     return score
//   }
// }
