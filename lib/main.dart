import 'package:flutter/material.dart';
import 'screens/student_list_screen.dart';
//import 'package:crud_operation/screens/student_list_screen.dart'; 


void main() {
  runApp(const StudentApp());
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student CRUD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const StudentListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
