// import { parseExpression } from 'cron-parser'

// export class CronDateUtils {
//   static getMonthGreaterDate = (): Date => {
//     const now = new Date()
//     const daysInMonth = new Date(
//       now.getFullYear(),
//       now.getMonth() + 1,
//       0,
//     ).getDate()
//     const greaterDateCron = parseExpression(`59 23 ${daysInMonth} * *`)

//     return new Date(greaterDateCron.next().getTime())
//   }

//   static getMonthLowerDate = (): Date => {
//     const lowerDateCron = parseExpression('0 0 1 * *')

//     return new Date(lowerDateCron.prev().getTime())
//   }

//   static getWeekGreaterDate = (): Date => {
//     const greaterDateCron = parseExpression('59 23 * * sun')
//     return new Date(greaterDateCron.next().getTime())
//   }

//   static getWeekLowerDate = (): Date => {
//     const lowerDateCron = parseExpression('0 0 * * mon')
//     return new Date(lowerDateCron.prev().getTime())
//   }
// }
