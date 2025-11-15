import 'package:polieats_frontend/main.dart';

class Attachment {
  final String fileName;
  final String filePath;
  final List<int> fileBytes;

  Attachment({required this.fileName, required this.filePath, required this.fileBytes});
}

class Assignment {
  final int? id; // Add this field
  final String title;
  final String description;
  final DateTime dueDate;
  final String course;
  final bool isCompleted;
  final List<Attachment>? attachments;

  Assignment({
    this.id, // Add this parameter
    required this.title,
    required this.description,
    required this.dueDate,
    required this.course,
    this.isCompleted = false,
    this.attachments,
  });
}

class Assignments {
  List<Assignment> assignments = [];

  Future<List<Assignment>> getAssignmentsForCourse(int courseId) async {
    try {
      assignments = await api.fetchAssignmentsForSubject(courseId);
      return assignments;
    } catch (e) {
      print('Error fetching assignments: $e');
      return [];
    }
  }

  Assignment? getAssignmentByName(String name) {
    try {
      return assignments.firstWhere((assignment) => assignment.title == name);
    } catch (e) {
      return null;
    }
  }
}