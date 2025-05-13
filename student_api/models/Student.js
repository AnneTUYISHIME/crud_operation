// models/Student.js
import mongoose from 'mongoose';

const studentSchema = new mongoose.Schema({
  firstName: { type: String, required: true },
  lastName: { type: String, required: true },
  regNumber: { type: String, required: true, unique: true },
  age: { type: Number, required: true },
  email: { type: String, required: true, unique: true },
}, { timestamps: true });

export default mongoose.models.Student || mongoose.model('Student', studentSchema);
