// routes/students.js

const express = require('express');
const router = express.Router();
const Student = require('../models/Student');

// Create a new student
router.post('/', async (req, res) => {
  try {
    const { name, regNumber, class: studentClass, age } = req.body;
    const newStudent = new Student({ name, regNumber, class: studentClass, age });
    const savedStudent = await newStudent.save();
    res.status(201).json(savedStudent);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Get all students
router.get('/', async (req, res) => {
  try {
    const students = await Student.find();
    res.json(students);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Get a student by ID
router.get('/:id', getStudent, (req, res) => {
  res.json(res.student);
});

// Update a student
router.put('/:id', getStudent, async (req, res) => {
  const { name, regNumber, class: studentClass, age } = req.body;
  if (name != null) res.student.name = name;
  if (regNumber != null) res.student.regNumber = regNumber;
  if (studentClass != null) res.student.class = studentClass;
  if (age != null) res.student.age = age;

  try {
    const updatedStudent = await res.student.save();
    res.json(updatedStudent);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Delete a student
router.delete('/:id', getStudent, async (req, res) => {
  try {
    await res.student.remove();
    res.json({ message: 'Student deleted' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Middleware to get student by ID
async function getStudent(req, res, next) {
  let student;
  try {
    student = await Student.findById(req.params.id);
    if (student == null) {
      return res.status(404).json({ message: 'Cannot find student' });
    }
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }

  res.student = student;
  next();
}

module.exports = router;
