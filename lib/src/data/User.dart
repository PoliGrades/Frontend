enum UserRole {
  PROFESSOR,
  STUDENT
}

class User {
  final int id;
  final String name;
  final String email;
  final UserRole role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role
  });

  // Helper method to convert string role to enum
  static UserRole roleFromString(String roleString) {
    switch (roleString.toUpperCase()) {
      case 'PROFESSOR':
        return UserRole.PROFESSOR;
      case 'STUDENT':
        return UserRole.STUDENT;
      default:
        return UserRole.STUDENT;
    }
  }

  // Helper method to convert enum role to string
  String roleToString() {
    return role.toString().split('.').last;
  }

  // Factory constructor for API responses
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: roleFromString(json['role']),
    );
  }

  // Method to convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': roleToString(),
    };
  }
}