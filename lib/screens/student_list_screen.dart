import 'package:flutter/material.dart';
import '../models/student.dart';
import '../service/api_service.dart';
import 'add_edit_student_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late Future<List<Student>> _students;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    _students = ApiService.getStudents();
  }

  void _delete(String id) async {
    await ApiService.deleteStudent(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Student deleted')));
    setState(() => _refreshList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student List')),
      body: FutureBuilder<List<Student>>(
        future: _students,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());

          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));

          final students = snapshot.data!;
          if (students.isEmpty) {
            return const Center(child: Text("No students found."));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Reg Number')),
                DataColumn(label: Text('Age')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Actions')),
              ],
              rows: students.map((student) {
                return DataRow(cells: [
                  DataCell(Text('${student.firstName} ${student.lastName}')),
                  DataCell(Text(student.regNumber)),
                  DataCell(Text(student.age.toString())),
                  DataCell(Text(student.email)),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddEditStudentScreen(student: student),
                            ),
                          );
                          if (updated == true) setState(() => _refreshList());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _delete(student.id!),
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditStudentScreen()),
          );
          if (added == true) setState(() => _refreshList());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
