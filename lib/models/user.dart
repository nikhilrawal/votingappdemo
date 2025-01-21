class User {
  final String id;
  final String name;
  final String aadhar;
  final String role;

  User(
      {required this.id,
      required this.name,
      required this.aadhar,
      required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      aadhar: json['aadhar'],
      role: json['role'],
    );
  }
}
