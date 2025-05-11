import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/student.dart';

const String baseUrl = 'http://localhost:3000/students';

class ApiService {
  static Future<List<Student>> fetchStudents() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Student.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  static Future<void> addStudent(Student student) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );
  }

  static Future<void> updateStudent(Student student) async {
    await http.put(
      Uri.parse('$baseUrl/${student.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );
  }

  static Future<void> deleteStudent(String id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}
