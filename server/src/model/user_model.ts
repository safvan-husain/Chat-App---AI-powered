import mongoose, { Schema, Document } from "mongoose";

export interface User extends Document {
  username: string;
  email: string;
  password: string;
  isOnline: boolean;
}

const userSchema: Schema = new Schema({
  username: { type: String, required: true },
  email: { type: String, required: true },
  password: { type: String, required: true },
  isOnline: { type: Boolean, default: false },
});

const UserModel = mongoose.model<User>("User", userSchema);
export default UserModel;
