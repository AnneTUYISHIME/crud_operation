class Student {
  String? id;
  String name;
  String regNumber;
  String studentClass;
  int age;

  Student({this.id, required this.name, required this.regNumber, required this.studentClass, required this.age});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'],
      name: json['name'],
      regNumber: json['regNumber'],
      studentClass: json['class'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'regNumber': regNumber,
      'class': studentClass,
      'age': age,
    };
  }
}
