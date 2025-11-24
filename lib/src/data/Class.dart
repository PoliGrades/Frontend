class CourseClass {
  final int id;
  final String name;
  final int subjectId;

  CourseClass({
    required this.id,
    required this.name,
    required this.subjectId,
  });

  // Factory constructor for API responses
  factory CourseClass.fromJson(Map<String, dynamic> json) {
    return CourseClass(
      id: json['id'],
      name: json['name'],
      subjectId: json['subjectId'],
    );
  }

  // Method to convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subjectId': subjectId,
    };
  }

  @override
  String toString() {
    return 'CourseClass{id: $id, name: $name, subjectId: $subjectId}';
  }
}

class CourseClassController {
  final List<CourseClass> _classes = [];

  // Method to add a class
  void addClass(CourseClass courseClass) {
    _classes.add(courseClass);
  }

  // Method to get a class by ID
  CourseClass? getClassById(int id) {
    try {
      return _classes.firstWhere((courseClass) => courseClass.id == id);
    } catch (e) {
      return null;
    }
  }

  // Method to get all classes
  List<CourseClass> get allClasses => _classes;

  // Method to set classes
  void setClasses(List<CourseClass> newClasses) {
    _classes.clear();
    _classes.addAll(newClasses);
  }
}

class Enrollment {
  final int id;
  final int studentId;
  final int classId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Enrollment({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor for API responses
  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      id: json['id'],
      studentId: json['studentId'],
      classId: json['classId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Method to convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'classId': classId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Enrollment{id: $id, studentId: $studentId, classId: $classId}';
  }
}