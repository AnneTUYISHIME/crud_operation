import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(StudentApp());
}

class StudentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student CRUD',
      home: StudentListPage(),
    );
  }
}

class Student {
  final String id;
  final String name;
  final String regNo;
  final String className;
  final int age;

  Student({
    required this.id,
    required this.name,
    required this.regNo,
    required this.className,
    required this.age,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'] ?? '', // in case _id is missing
      name: json['name'] ?? '',
      regNo: json['regNo'] ?? '',
      className: json['class'] ?? '',
      age: json['age'] ?? 0,
    );
  }
}

class StudentListPage extends StatefulWidget {
  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  List<Student> students = [];
 // final response = await http.get(Uri.parse('http://localhost:3000/students'));


  final String baseUrl = 'http://10.0.2.2:3000/students'; // Update if needed

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          students = data.map((json) => Student.fromJson(json)).toList();
        });
      } else {
        print('Error fetching students: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  Future<void> addStudent(String name, String regNo, String className, int age) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'regNo': regNo,
          'class': className,
          'age': age,
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        Navigator.of(context).pop(); // Close the dialog
        fetchStudents(); // Refresh list
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student added successfully')),
        );
      } else {
        print('Failed to add student: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add student')),
        );
      }
    } catch (e) {
      print('Error adding student: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void showAddStudentDialog() {
    final nameController = TextEditingController();
    final regNoController = TextEditingController();
    final classController = TextEditingController();
    final ageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Student'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: regNoController,
                decoration: InputDecoration(labelText: 'Reg No'),
              ),
              TextField(
                controller: classController,
                decoration: InputDecoration(labelText: 'Class'),
              ),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Age'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final regNo = regNoController.text.trim();
              final className = classController.text.trim();
              final ageText = ageController.text.trim();

              if (name.isEmpty || regNo.isEmpty || className.isEmpty || ageText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please fill all fields")),
                );
                return;
              }

              final age = int.tryParse(ageText);
              if (age == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Age must be a number")),
                );
                return;
              }

              addStudent(name, regNo, className, age);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
      ),
      body: students.isEmpty
          ? Center(child: Text('No students available'))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Reg No')),
                  DataColumn(label: Text('Class')),
                  DataColumn(label: Text('Age')),
                ],
                rows: students.map((student) {
                  return DataRow(cells: [
                    DataCell(Text(student.name)),
                    DataCell(Text(student.regNo)),
                    DataCell(Text(student.className)),
                    DataCell(Text(student.age.toString())),
                  ]);
                }).toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddStudentDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
