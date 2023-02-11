import mongoose, { Schema, Document } from "mongoose";
import { messageSchema, Message } from "./message_model";
export interface User extends Document {
  username: string;
  email: string;
  password: string;
  isOnline: boolean;
  messages: Array<Message>;
}

const userSchema: Schema = new Schema({
  username: { type: String, required: true },
  email: { type: String, required: true },
  password: { type: String, required: true },
  isOnline: { type: Boolean, default: false },
  messages: [ messageSchema ]

});

const UserModel = mongoose.model<User>("User", userSchema);
export default UserModel;
