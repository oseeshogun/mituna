import { ModelOptions, Prop, getModelForClass } from '@typegoose/typegoose'

@ModelOptions({ schemaOptions: { collection: 'rewards' } })
export class Reward {
  @Prop({ required: true })
  uid: string

  @Prop({ required: true })
  topaz: number

  @Prop({ required: false, default: 0 })
  duration: number

  @Prop({ required: true })
  createdAt: Date
}

export const RewardModel = getModelForClass(Reward)
