// api/students/index.js
import connectDB from '../../../utils/db';
import Student from '../../../models/Student';

export default async function handler(req, res) {
  await connectDB();

  if (req.method === 'GET') {
    const students = await Student.find();
    return res.status(200).json(students);
  }

  if (req.method === 'POST') {
    const student = await Student.create(req.body);
    return res.status(201).json(student);
  }

  return res.status(405).end(); // Method not allowed
}
