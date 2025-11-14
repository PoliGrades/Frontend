import 'package:flutter/material.dart';

class Course {
  final String name;
  final String description;
  final String instructor;
  final Color color;
  final Color accentColor;
  final IconData icon;

  Course({
    required this.name,
    required this.description,
    required this.instructor,
    required this.color,
    required this.accentColor,
    required this.icon,
  });
}

class Courses {
  List<Course> courses = [
    Course(
      name: 'Matemática',
      description: 'Aprenda os fundamentos da matemática.',
      instructor: 'Prof. João Silva',
      color: Colors.blue,
      accentColor: Colors.blue.shade50,
      icon: Icons.calculate,
    ),
    Course(
      name: 'Física',
      description: 'Explore os conceitos básicos da física.',
      instructor: 'Prof. Maria Oliveira',
      color: Colors.red,
      accentColor: Colors.red.shade50,
      icon: Icons.science,
    ),
    Course(
      name: 'Química',
      description: 'Descubra os segredos da química.',
      instructor: 'Prof. Carlos Souza',
      color: Colors.green,
      accentColor: Colors.green.shade50,
      icon: Icons.biotech,
    ),
    Course(
      name: 'Biologia',
      description: 'Entenda os processos da vida.',
      instructor: 'Prof. Ana Pereira',
      color: Colors.orange,
      accentColor: Colors.orange.shade50,
      icon: Icons.eco,
    ),
    Course(
      name: 'História',
      description: 'Reviva os eventos históricos mais importantes.',
      instructor: 'Prof. Pedro Costa',
      color: Colors.purple,
      accentColor: Colors.purple.shade50,
      icon: Icons.history_edu,
    ),
    Course(
      name: 'Geografia',
      description: 'Explore o mundo ao seu redor.',
      instructor: 'Prof. Laura Fernandes',
      color: Colors.teal,
      accentColor: Colors.teal.shade50,
      icon: Icons.public,
    ),
  ];

  Courses();

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

  List<Course> getCoursesByInstructor(String instructor) {
    return courses.where((course) => course.instructor == instructor).toList();
  }
}