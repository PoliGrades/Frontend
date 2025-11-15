import 'package:flutter/material.dart';

class Course {
  final int id;
  final String name;
  final String description;
  final Color color;
  final Color accentColor;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.accentColor,
  });
}

class CourseController {
  List<Course> courses = [
    Course(
      id: 1,
      name: 'Matemática',
      description: 'Aprenda os fundamentos da matemática.',
      color: const Color(0xFF2196F3),
      accentColor: const Color(0xFFE3F2FD),
    ),
    Course(
      id: 2,
      name: 'Física',
      description: 'Explore os conceitos básicos da física.',
      color: Colors.red,
      accentColor: Colors.red.shade50,
    ),
    Course(
      id: 3,
      name: 'Química',
      description: 'Descubra os segredos da química.',
      color: Colors.green,
      accentColor: Colors.green.shade50,
    ),
    Course(
      id: 4,
      name: 'Biologia',
      description: 'Entenda os processos da vida.',
      color: Colors.orange,
      accentColor: Colors.orange.shade50,
    ),
    Course(
      id: 5,
      name: 'História',
      description: 'Reviva os eventos históricos mais importantes.',
      color: Colors.purple,
      accentColor: Colors.purple.shade50,
    ),
    Course(
      id: 6,
      name: 'Geografia',
      description: 'Explore o mundo ao seu redor.',
      color: Colors.teal,
      accentColor: Colors.teal.shade50,
    ),
  ];

  CourseController();

  List<Course> get allCourses => courses;

  Course? getCourseById(int id) {
    return courses.firstWhere((course) => course.id == id);
  }

  Course? getCourseByName(String name) {
    return courses.firstWhere((course) => course.name == name);
  }

  void addCourse(Course course) {
    courses.add(course);
  }

  void removeCourse(String name) {
    courses.removeWhere((course) => course.name == name);
  }

  // List<Course> getCoursesByInstructor(String instructor) {
  //   return courses.where((course) => course.instructor == instructor).toList();
  // }

  void setCourses(List<Course> newCourses) {
    courses = newCourses;
  }

  void fromJson(List<dynamic> jsonData) {
    courses = jsonData.map((course) {
      final name = course['name']?.toString() ?? '';
      final description = course['description']?.toString() ?? '';

      // parse color hex string (accepts "#RRGGBB", "RRGGBB", "AARRGGBB", etc.)
      String rawColor = course['color']?.toString() ?? '#FF000000';
      rawColor = rawColor.replaceFirst('#', '');
      if (rawColor.length == 6) {
        rawColor = 'FF$rawColor'; // add opaque alpha if missing
      }
      final color = Color(int.parse(rawColor, radix: 16));

      // accentColor falls back to the same color if not provided
      String rawAccent = course['accentColor']?.toString() ?? course['color']?.toString() ?? '#FF000000';
      rawAccent = rawAccent.replaceFirst('#', '');
      if (rawAccent.length == 6) rawAccent = 'FF$rawAccent';
      final accentColor = Color(int.parse(rawAccent, radix: 16));

      return Course(
        id: int.parse(course['id']?.toString() ?? '0'),
        name: name,
        description: description,
        color: color,
        accentColor: accentColor,
      );
    }).toList();
  }
}