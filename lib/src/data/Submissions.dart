import 'package:polieats_frontend/main.dart';

enum SubmissionStatus {
  SUBMITTED,
  GRADED,
  LATE,
  NOT_SUBMITTED
}

extension SubmissionStatusExtension on SubmissionStatus {
  String get value {
    switch (this) {
      case SubmissionStatus.SUBMITTED:
        return 'SUBMITTED';
      case SubmissionStatus.GRADED:
        return 'GRADED';
      case SubmissionStatus.LATE:
        return 'LATE';
      case SubmissionStatus.NOT_SUBMITTED:
        return 'NOT_SUBMITTED';
    }
  }

  static SubmissionStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'SUBMITTED':
        return SubmissionStatus.SUBMITTED;
      case 'GRADED':
        return SubmissionStatus.GRADED;
      case 'LATE':
        return SubmissionStatus.LATE;
      case 'NOT_SUBMITTED':
        return SubmissionStatus.NOT_SUBMITTED;
      default:
        return SubmissionStatus.NOT_SUBMITTED;
    }
  }
}

class SubmissionAttachment {
  final int? id;
  final int? submissionId;
  final String fileName;
  final String filePath;
  final List<int> fileBytes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SubmissionAttachment({
    this.id,
    this.submissionId,
    required this.fileName,
    required this.filePath,
    required this.fileBytes,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor for API responses
  factory SubmissionAttachment.fromJson(Map<String, dynamic> json) {
    return SubmissionAttachment(
      id: json['id'],
      submissionId: json['submissionId'],
      fileName: json['fileName'],
      filePath: json['filePath'],
      fileBytes: List<int>.empty(), // File bytes would be loaded separately
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Method to convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'submissionId': submissionId,
      'fileName': fileName,
      'filePath': filePath,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Submission {
  final int id;
  final int taskId;
  final int studentId;
  final double? grade;
  final String? feedback;
  final bool hasAttachment;
  final bool isGraded;
  final DateTime submittedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<SubmissionAttachment>? attachments;

  Submission({
    required this.id,
    required this.taskId,
    required this.studentId,
    this.grade,
    this.feedback,
    this.hasAttachment = false,
    this.isGraded = false,
    required this.submittedAt,
    required this.createdAt,
    required this.updatedAt,
    this.attachments,
  });

  // Factory constructor for API responses
  factory Submission.fromJson(Map<String, dynamic> json) {
    List<SubmissionAttachment>? attachments;
    if (json['attachments'] != null) {
      attachments = (json['attachments'] as List<dynamic>)
          .map((att) => SubmissionAttachment.fromJson(att))
          .toList();
    }

    return Submission(
      id: json['id'],
      taskId: json['taskId'],
      studentId: json['studentId'],
      grade: json['grade']?.toDouble(),
      feedback: json['feedback'],
      hasAttachment: json['hasAttachment'] ?? false,
      isGraded: json['isGraded'] ?? false,
      submittedAt: DateTime.parse(json['submittedAt']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      attachments: attachments,
    );
  }

  // Method to convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'studentId': studentId,
      'grade': grade,
      'feedback': feedback,
      'hasAttachment': hasAttachment,
      'isGraded': isGraded,
      'submittedAt': submittedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'attachments': attachments?.map((att) => att.toJson()).toList(),
    };
  }

  // Helper methods
  // bool get isLate {
  //   return status == SubmissionStatus.LATE;
  // }

  bool get hasGrade {
    return grade != null && grade! >= 0;
  }

  // String get statusDisplay {
  //   switch (status) {
  //     case SubmissionStatus.SUBMITTED:
  //       return 'Submitted';
  //     case SubmissionStatus.GRADED:
  //       return 'Graded';
  //     case SubmissionStatus.LATE:
  //       return 'Late Submission';
  //     case SubmissionStatus.NOT_SUBMITTED:
  //       return 'Not Submitted';
  //   }
  // }
}

class Submissions {
  List<Submission> submissions = [];

  Future<List<Submission>> getSubmissionsForTask(int taskId) async {
    try {
      submissions = await api.fetchTaskSubmissions(taskId);
      return submissions;
    } catch (e) {
      print('Error fetching submissions: $e');
      return [];
    }
  }

  Future<List<Submission>> getSubmissionsForStudent(int studentId) async {
    try {
      // For now, we'll fetch all submissions and filter by student
      // This would need a specific API endpoint for student submissions
      final allSubmissions = submissions.where((s) => s.studentId == studentId).toList();
      return allSubmissions;
    } catch (e) {
      print('Error fetching student submissions: $e');
      return [];
    }
  }

  Submission? getSubmissionById(int id) {
    try {
      return submissions.firstWhere((submission) => submission.id == id);
    } catch (e) {
      return null;
    }
  }

  // List<Submission> getSubmissionsByStatus(SubmissionStatus status) {
  //   return submissions.where((submission) => submission.status == status).toList();
  // }

  List<Submission> getGradedSubmissions() {
    return submissions.where((submission) => submission.isGraded).toList();
  }

  // List<Submission> getUngradedSubmissions() {
  //   return submissions.where((submission) => !submission.isGraded && submission.status != SubmissionStatus.NOT_SUBMITTED).toList();
  // }
}

// Backwards compatibility - Attachment is now SubmissionAttachment
typedef Attachment = SubmissionAttachment;
