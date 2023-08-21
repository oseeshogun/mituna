import mongoose from 'mongoose'

const rewardSchema = new mongoose.Schema(
  {
    uid: String,
    topaz: Number,
    duration: Number,
    createdAt: Date,
  },
  {
    timestamps: true,
  },
)

const Reward = mongoose.model('rewards', rewardSchema)

export { rewardSchema, Reward }
