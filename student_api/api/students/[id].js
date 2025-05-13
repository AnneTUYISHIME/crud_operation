// api/students/[id].js
import connectDB from '../../../utils/db';
import Student from '../../../models/Student';

export default async function handler(req, res) {
  await connectDB();
  const { id } = req.query;

  if (req.method === 'PUT') {
    const updated = await Student.findByIdAndUpdate(id, req.body, { new: true });
    return res.status(200).json(updated);
  }

  if (req.method === 'DELETE') {
    await Student.findByIdAndDelete(id);
    return res.status(204).end();
  }

  return res.status(405).end();
}
