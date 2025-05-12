import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/students';

  static Future<List<Student>> getStudents() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      List jsonList = json.decode(res.body);
      return jsonList.map((e) => Student.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  static Future<Student> createStudent(Student student) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );
    if (res.statusCode == 201) {
      return Student.fromJson(json.decode(res.body));
    } else {
      throw Exception('Failed to create student');
    }
  }

  static Future<Student> updateStudent(String id, Student student) async {
    final res = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );
    if (res.statusCode == 200) {
      return Student.fromJson(json.decode(res.body));
    } else {
      throw Exception('Failed to update student');
    }
  }

  static Future<void> deleteStudent(String id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));
    if (res.statusCode != 200) {
      throw Exception('Failed to delete student');
    }
  }
}
