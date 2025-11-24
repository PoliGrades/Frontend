import 'package:flutter/material.dart';

class Subject {
  final int id;
  final String name;
  final String description;
  final String color;
  final String accentColor;

  Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.accentColor,
  });

  // Helper method to get Flutter Color from hex string
  Color get colorAsFlutterColor {
    String rawColor = color.replaceFirst('#', '');
    if (rawColor.length == 6) {
      rawColor = 'FF$rawColor';
    }
    return Color(int.parse(rawColor, radix: 16));
  }

  // Helper method to get Flutter Color from accent hex string
  Color get accentColorAsFlutterColor {
    String rawAccent = accentColor.replaceFirst('#', '');
    if (rawAccent.length == 6) {
      rawAccent = 'FF$rawAccent';
    }
    return Color(int.parse(rawAccent, radix: 16));
  }

  // Factory constructor for API responses
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      color: json['color'] ?? '#FF000000',
      accentColor: json['accentColor'] ?? json['color'] ?? '#FF000000',
    );
  }

  // Method to convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color,
      'accentColor': accentColor,
    };
  }
}

// Backwards compatibility - Course is now an alias for Subject
typedef Course = Subject;

class SubjectController {
  List<Subject> subjects = [];

  List<Subject> get allSubjects => subjects;

  Subject? getSubjectById(int id) {
    try {
      return subjects.firstWhere((subject) => subject.id == id);
    } catch (e) {
      return null;
    }
  }

  Subject? getSubjectByName(String name) {
    try {
      return subjects.firstWhere((subject) => subject.name == name);
    } catch (e) {
      return null;
    }
  }

  void addSubject(Subject subject) {
    subjects.add(subject);
  }

  void removeSubject(String name) {
    subjects.removeWhere((subject) => subject.name == name);
  }

  void setSubjects(List<Subject> newSubjects) {
    subjects = newSubjects;
  }

  void fromJson(List<dynamic> jsonData) {
    subjects = jsonData.map((subject) => Subject.fromJson(subject)).toList();
  }
}

// Backwards compatibility
typedef CourseController = SubjectController;