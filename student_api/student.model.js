// models/Student.js

const mongoose = require('mongoose');

const studentSchema = new mongoose.Schema({
  name: { type: String, required: true },
  regNumber: { type: String, required: true },
  class: { type: String, required: true },
  age: { type: Number, required: true },
});

module.exports = mongoose.model('Student', studentSchema);
