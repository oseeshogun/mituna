import { ModelOptions, Prop, getModelForClass } from '@typegoose/typegoose'

@ModelOptions({
  schemaOptions: { timestamps: true, collection: 'questions_of_the_days' },
})
export class QuestionOfTheDay {
  @Prop({ unique: true, required: true })
  date: string

  @Prop({ unique: true, required: true })
  question: string

  @Prop({ required: true, type: [String] })
  assertions: string[]

  @Prop({ required: true })
  reponse: string
}

export const QuestionOfTheDayModel = getModelForClass(QuestionOfTheDay)
