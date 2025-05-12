import 'package:flutter/material.dart';
import '../models/student.dart';
import '../service/api_service.dart';

class AddEditStudentScreen extends StatefulWidget {
  final Student? student;
  const AddEditStudentScreen({super.key, this.student});

  @override
  State<AddEditStudentScreen> createState() => _AddEditStudentScreenState();
}

class _AddEditStudentScreenState extends State<AddEditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _regNumber = TextEditingController();
  final _age = TextEditingController();
  final _email = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _firstName.text = widget.student!.firstName;
      _lastName.text = widget.student!.lastName;
      _regNumber.text = widget.student!.regNumber;
      _age.text = widget.student!.age.toString();
      _email.text = widget.student!.email;
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final student = Student(
      id: widget.student?.id,
      firstName: _firstName.text,
      lastName: _lastName.text,
      regNumber: _regNumber.text,
      age: int.parse(_age.text),
      email: _email.text,
    );

    try {
      if (widget.student == null) {
        await ApiService.createStudent(student);
      } else {
        await ApiService.updateStudent(student.id!, student);
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.student != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Student' : 'Add Student')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _firstName, decoration: const InputDecoration(labelText: 'First Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _lastName, decoration: const InputDecoration(labelText: 'Last Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _regNumber, decoration: const InputDecoration(labelText: 'Reg Number'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _age, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _save, child: Text(isEditing ? 'Update' : 'Add')),
            ],
          ),
        ),
      ),
    );
  }
}
