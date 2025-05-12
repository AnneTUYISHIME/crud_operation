class Student {
  final String? id;
  final String firstName;
  final String lastName;
  final String regNumber;
  final int age;
  final String email;

  Student({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.regNumber,
    required this.age,
    required this.email,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      regNumber: json['regNumber'],
      age: json['age'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'regNumber': regNumber,
      'age': age,
      'email': email,
    };
  }
}
