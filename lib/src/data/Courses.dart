import 'package:flutter/material.dart';

class Course {
  final String name;
  final String description;
  final Color color;
  final Color accentColor;

  Course({
    required this.name,
    required this.description,
    required this.color,
    required this.accentColor,
  });
}

class CourseController {
  List<Course> courses = [
    // Course(
    //   name: 'Matemática',
    //   description: 'Aprenda os fundamentos da matemática.',
    //   color: Colors.blue,
    //   accentColor: Colors.blue.shade50,
    // ),
    // Course(
    //   name: 'Física',
    //   description: 'Explore os conceitos básicos da física.',
    //   color: Colors.red,
    //   accentColor: Colors.red.shade50,
    // ),
    // Course(
    //   name: 'Química',
    //   description: 'Descubra os segredos da química.',
    //   color: Colors.green,
    //   accentColor: Colors.green.shade50,
    // ),
    // Course(
    //   name: 'Biologia',
    //   description: 'Entenda os processos da vida.',
    //   color: Colors.orange,
    //   accentColor: Colors.orange.shade50,
    // ),
    // Course(
    //   name: 'História',
    //   description: 'Reviva os eventos históricos mais importantes.',
    //   color: Colors.purple,
    //   accentColor: Colors.purple.shade50,
    // ),
    // Course(
    //   name: 'Geografia',
    //   description: 'Explore o mundo ao seu redor.',
    //   color: Colors.teal,
    //   accentColor: Colors.teal.shade50,
    // ),
  ];

  CourseController();

  List<Course> get allCourses => courses;

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
        name: name,
        description: description,
        color: color,
        accentColor: accentColor,
      );
    }).toList();
  }
}