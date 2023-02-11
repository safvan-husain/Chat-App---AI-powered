import mongoose, { Schema, Document } from 'mongoose';

export interface Message extends Document {
  senderId: string;
  receiverId: string;
  msgText: string;
  isRead: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const messageSchema: Schema = new mongoose.Schema({
  senderId: {
    type: String,
    required: true,
  },
  receiverId: {
    type: String,
    required: true,
  },
  msgText: {
    type: String,
    required: true
  },
  isRead: {
    type: Boolean,
    default: false
  }
}, {
  timestamps: true
});

const Message = mongoose.model<Message>('Message', messageSchema);

export { Message, messageSchema}
