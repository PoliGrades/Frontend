import 'dart:convert';

import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:polieats_frontend/main.dart';
import 'package:polieats_frontend/src/data/Class.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Notices.dart';
import 'package:polieats_frontend/src/data/Submissions.dart';
import 'package:polieats_frontend/src/data/Tasks.dart';
import 'package:polieats_frontend/src/data/User.dart';

class Api {
  final String baseUrl = 'http://localhost:3000';
  late Dio dio;
  late BrowserHttpClientAdapter httpClientAdapter;

  Api() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
    httpClientAdapter = BrowserHttpClientAdapter();
    httpClientAdapter.withCredentials = true;
    dio.httpClientAdapter = httpClientAdapter;
  }

  // Authentication Methods
  Future<User> loginUser(String email, String password) async {
    final response = await dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
      options: Options(
        validateStatus: (status) => status == 200 || status == 401,
      )
    );

    if (response.statusCode == 401) {
      throw Exception('Failed to login: ${response.statusCode}');
    }

    Map<String, dynamic> data = response.data;

    globals.currentUser = User(
      email: data['email'].toString(),
      name: data['name'].toString(),
      id: data['id'],
      role: UserRole.values.firstWhere((e) => e.toString() == 'UserRole.${data['role'].toString().toUpperCase()}')
    );

    final courses = await dio.get(
      '/subjects',
      options: Options(
        validateStatus: (status) => status == 200 || status == 500 || status == 401,
      )
    );

    if (courses.statusCode != 200) {
      throw Exception('Failed to fetch courses: ${courses.statusCode}');
    }

    globals.courseController.fromJson(courses.data);

    return globals.currentUser;
  }

  Future<User> registerUser(String name, String email, String password, String role) async {
    final response = await dio.post(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      },
      options: Options(
        validateStatus: (status) => status == 201 || status == 400 || status == 401,
      )
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register user: ${response.statusCode}');
    }

    Map<String, dynamic> data = response.data['data'];

    return User(
      id: data['id'],
      name: data['name'].toString(),
      email: data['email'].toString(),
      role: UserRole.values.firstWhere((e) => e.toString() == 'UserRole.${data['role'].toString().toUpperCase()}')
    );
  }

  Future<void> logoutUser() async {
    final response = await dio.post(
      '/auth/logout',
      options: Options(
        validateStatus: (status) => status == 200 || status == 401,
      )
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to logout: ${response.statusCode}');
    }
  }

  // User Management Methods
  Future<List<User>> fetchProfessors() async {
    final response = await dio.get(
      '/professors',
      options: Options(
        validateStatus: (status) => status == 200 || status == 500 || status == 401,
      )
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch professors: ${response.statusCode}');
    }

    List<dynamic> data = response.data;
    List<User> professors = data.map((prof) => User(
      email: prof['email'].toString(),
      name: prof['name'].toString(),
      id: prof['id'],
      role: UserRole.values.firstWhere((e) => e.toString() == 'UserRole.${prof['role'].toString().toUpperCase()}'),
    )).toList();

    return professors;
  }

  Future<List<User>> fetchStudents() async {
    final response = await dio.get(
      '/students',
      options: Options(
        validateStatus: (status) => status == 200 || status == 500 || status == 401,
      )
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch students: ${response.statusCode}');
    }

    List<dynamic> data = response.data;
    List<User> students = data.map((student) => User(
      id: student['id'],
      name: student['name'].toString(),
      email: student['email'].toString(),
      role: UserRole.values.firstWhere((e) => e.toString() == 'UserRole.${student['role'].toString().toUpperCase()}'),
    )).toList();

    return students;
  }

  // Warning/Notice Methods
  Future<List<Notice>> fetchNotices() async {
    final response = await dio.get(
      '/warnings',
      options: Options(
        validateStatus: (status) => status == 200 || status == 500 || status == 401,
      )
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch notices: ${response.statusCode}');
    }

    List<dynamic> data = response.data;
    List<Notice> notices = data.map((notice) => Notice(
      title: notice['title'].toString(),
      content: notice['description'].toString(),
      date: DateTime.parse(notice['timestamp'].toString()),
      course: notice['subjectName'].toString(),
      owner: notice['userName'].toString()
    )).toList();

    return notices;
  }

  Future<Notice> createNotice(String title, String content, int subjectId) async {
    final response = await dio.post(
      '/warning',
      data: {
        'title': title,
        'description': content,
        'subjectId': subjectId,
      },
      options: Options(
        validateStatus: (status) => status == 201 || status == 400 || status == 401,
      )
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create notice: ${response.statusCode}');
    }

    Map<String, dynamic> data = response.data;

    return Notice(
      title: data['title'].toString(),
      content: data['description'].toString(),
      date: DateTime.parse(data['timestamp'].toString()),
      course: data['subjectName'].toString(),
      owner: data['userName'].toString()
    );
  }

  // Subject/Course Methods
  Future<List<Course>> fetchCourses() async {
    final response = await dio.get(
      '/subjects',
      options: Options(
        validateStatus: (status) => status == 200 || status == 500 || status == 401,
      )
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch courses: ${response.statusCode}');
    }

    List<dynamic> data = response.data;
    List<Course> courses = data.map((course) {
      final name = course['name']?.toString() ?? '';
      final description = course['description']?.toString() ?? '';

      String rawColor = course['color']?.toString() ?? '#FF000000';
      rawColor = rawColor.replaceFirst('#', '');
      if (rawColor.length == 6) {
        rawColor = 'FF$rawColor';
      }
      final color = Color(int.parse(rawColor, radix: 16));

      String rawAccent = course['accentColor']?.toString() ?? course['color']?.toString() ?? '#FF000000';
      rawAccent = rawAccent.replaceFirst('#', '');
      if (rawAccent.length == 6) rawAccent = 'FF$rawAccent';
      final accentColor = Color(int.parse(rawAccent, radix: 16));

      return Course(
        id: int.parse(course['id']?.toString() ?? '0'),
        name: name,
        description: description,
        color: course['color']!.toString(),
        accentColor: course['accentColor']!.toString(),
      );
    }).toList();

    return courses;
  }

  Future<Course> fetchSubjectById(int subjectId) async {
    final response = await dio.get(
      '/subject/$subjectId',
      options: Options(
        validateStatus: (status) => status == 200 || status == 404 || status == 401,
      )
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch subject: ${response.statusCode}');
    }

    Map<String, dynamic> data = response.data;
    
    String rawColor = data['color']?.toString() ?? '#FF000000';
    rawColor = rawColor.replaceFirst('#', '');
    if (rawColor.length == 6) {
      rawColor = 'FF$rawColor';
    }
    final color = Color(int.parse(rawColor, radix: 16));

    String rawAccent = data['accentColor']?.toString() ?? '#FF000000';
    rawAccent = rawAccent.replaceFirst('#', '');
    if (rawAccent.length == 6) {
      rawAccent = 'FF$rawAccent';
    }
    final accentColor = Color(int.parse(rawAccent, radix: 16));

    return Course(
      id: data['id'],
      name: data['name'].toString(),
      description: data['description'].toString(),
      color: data['color']!.toString(),
      accentColor: data['accentColor']!.toString(),
    );
  }

  Future<List<Course>> fetchMySubjects() async {
    final response = await dio.get(
      '/subject/professor/my-subjects',
      options: Options(
        validateStatus: (status) => status == 200 || status == 403 || status == 401,
      )
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch my subjects: ${response.statusCode}');
    }

    List<dynamic> data = response.data;
    List<Course> courses = data.map((course) {
      String rawColor = course['color']?.toString() ?? '#FF000000';
      rawColor = rawColor.replaceFirst('#', '');
      if (rawColor.length == 6) {
        rawColor = 'FF$rawColor';
      }
      final color = Color(int.parse(rawColor, radix: 16));

      String rawAccent = course['accentColor']?.toString() ?? '#FF000000';
      rawAccent = rawAccent.replaceFirst('#', '');
      if (rawAccent.length == 6) rawAccent = 'FF$rawAccent';
      final accentColor = Color(int.parse(rawAccent, radix: 16));

      return Course(
        id: course['id'],
        name: course['name'].toString(),
        description: course['description'].toString(),
        color: course['color']!.toString(),
        accentColor: course['accentColor']!.toString(),
      );
    }).toList();

    return courses;
  }

  Future<Course> createSubject(String name, String description, String color, String accentColor) async {
    final response = await dio.post(
      '/subject',
      data: {
        'name': name,
        'description': description,
        'color': color.isEmpty ? '#FF000000' : color,
        'accentColor': accentColor.isEmpty ? '#FF000000' : accentColor,
      },
      options: Options(
        validateStatus: (status) => status == 201 || status == 400 || status == 401,
      )
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create subject: ${response.statusCode}');
    }

    Map<String, dynamic> data = response.data;
    
    String rawColor = data['color']?.toString() ?? '#FF000000';
    rawColor = rawColor.replaceFirst('#', '');
    if (rawColor.length == 6) {
      rawColor = 'FF$rawColor';
    }
    final colorParsed = Color(int.parse(rawColor, radix: 16));

    String rawAccentColor = data['accentColor']?.toString() ?? '#FF000000';
    rawAccentColor = rawAccentColor.replaceFirst('#', '');
    if (rawAccentColor.length == 6) {
      rawAccentColor = 'FF$rawAccentColor';
    }
    final accentColorParsed = Color(int.parse(rawAccentColor, radix: 16));

    return Course(
      id: data['id'],
      name: data['name'].toString(),
      description: data['description'].toString(),
      color: data['color']!.toString(),
      accentColor: data['accentColor']!.toString(),
    );
  }

  // Class Methods
  Future<List<CourseClass>> fetchClasses() async {
    final response = await dio.get(
      '/classes',
      options: Options(
        validateStatus: (status) => status == 200 || status == 500 || status == 401,
      )
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch classes: ${response.statusCode}');
    }

    List<dynamic> data = response.data;
    List<CourseClass> classes = data.map((classItem) => CourseClass(
      id: classItem['id'],
      name: classItem['name'].toString(),
      subjectId: classItem['subjectId'],
    )).toList();

    return classes;
  }

  Future<CourseClass> createClass(String name, int subjectId) async {
    final response = await dio.post(
      '/classes',
      data: {
        'name': name,
        'subjectId': subjectId,
      },
      options: Options(
        validateStatus: (status) => status == 201 || status == 400 || status == 401,
      )
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create class: ${response.statusCode}');
    }

    Map<String, dynamic> data = response.data;

    return CourseClass(
      id: data['id'],
      name: data['name'].toString(),
      subjectId: data['subjectId'],
    );
  }

  Future<List<CourseClass>> fetchClassesForSubject(int subjectId) async {
    final response = await dio.get(
      '/class/subject/$subjectId',
      options: Options(
        validateStatus: (status) => status == 200 || status == 500 || status == 401,
      )
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch classes for subject: ${response.statusCode}');
    }

    List<dynamic> data = response.data;
    List<CourseClass> classes = data.map((classItem) => CourseClass(
      id: classItem['id'],
      name: classItem['name'].toString(),
      subjectId: classItem['subjectId'],
    )).toList();

    return classes;
  }

  // Enrollment Methods
  Future<void> enrollStudent(int studentId, int classId) async {
    final response = await dio.post(
      '/enrollments',
      data: {
        'studentId': studentId,
        'classId': classId,
      },
      options: Options(
        validateStatus: (status) => status == 201 || status == 400 || status == 401,
      )
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to enroll student: ${response.statusCode}');
    }
  }

  // Task/Assignment Methods
  Future<void> createAssignment(String title, String description, DateTime dueDate, int classId, List<TaskAttachment> attachments) async {
    final formData = FormData.fromMap({
      'attachments': attachments.map((attachment) => MultipartFile.fromBytes(attachment.fileBytes, filename: attachment.fileName)).toList(),
      'body': jsonEncode({
        'classId': classId,
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
      })
    });

    final response = await dio.post(
      '/task',
      data: formData,
      options: Options(
        validateStatus: (status) => status == 201 || status == 400 || status == 401 || status == 200,
        contentType: 'multipart/form-data',
      )
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create assignment: ${response.statusCode}');
    }
  }

  Future<List<Task>> fetchAllTasks() async {
    final response = await dio.get(
      '/tasks',
      options: Options(
        validateStatus: (status) => status == 200 || status == 500 || status == 401,
      )
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch tasks: ${response.statusCode}');
    }

    List<dynamic> data = response.data;
    List<Task> tasks = data.map((task) {
      List<TaskAttachment>? attachments;
      if (task['attachments'] != null) {
        attachments = (task['attachments'] as List<dynamic>).map((att) => TaskAttachment(
          id: att['id'],
          taskId: att['taskId'],
          fileName: att['fileName'].toString(),
          filePath: att['filePath'].toString(),
          fileBytes: List<int>.empty(),
          createdAt: att['createdAt'] != null ? DateTime.parse(att['createdAt']) : null,
          updatedAt: att['updatedAt'] != null ? DateTime.parse(att['updatedAt']) : null,
        )).toList();
      }

      return Task(
        id: task['id'],
        classId: task['classId'],
        title: task['title'].toString(),
        description: task['description'].toString(),
        hasAttachment: task['hasAttachment'] ?? false,
        dueDate: DateTime.parse(task['dueDate'].toString()),
        attachments: attachments,
      );
    }).toList();

    return tasks;
  }

  Future<List<Task>> fetchAssignmentsForSubject(int subjectId) async {
    final response = await dio.get(
      '/tasks/subject/$subjectId',
      options: Options(
        validateStatus: (status) => status == 200 || status == 500 || status == 401,
      )
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch assignments: ${response.statusCode}');
    }

    List<dynamic> data = response.data;
    List<Task> tasks = data.map((task) {
      return Task(
        id: task['id'],
        classId: task['classId'],
        title: task['title'].toString(),
        description: task['description'].toString(),
        dueDate: DateTime.parse(task['dueDate'].toString())
      );
    }).toList();

    return tasks;
  }

  Future<Task> fetchAssignmentById(int assignmentId) async {
    final response = await dio.get(
      '/task/$assignmentId',
      options: Options(
        validateStatus: (status) => status == 200 || status == 404 || status == 401,
      )
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch assignment: ${response.statusCode}');
    }

    Map<String, dynamic> data = response.data;
    
    List<TaskAttachment>? attachments;
    if (data['attachments'] != null) {
      attachments = (data['attachments'] as List<dynamic>).map((att) => TaskAttachment(
        id: att['id'],
        taskId: att['taskId'],
        fileName: att['fileName'].toString(),
        filePath: att['filePath'].toString(),
        fileBytes: List<int>.empty(),
        createdAt: att['createdAt'] != null ? DateTime.parse(att['createdAt']) : null,
        updatedAt: att['updatedAt'] != null ? DateTime.parse(att['updatedAt']) : null,
      )).toList();
    }

    return Task(
      id: data['id'],
      classId: data['classId'],
      title: data['title'].toString(),
      description: data['description'].toString(),
      hasAttachment: data['hasAttachment'] ?? false,
      dueDate: DateTime.parse(data['dueDate'].toString()),
      attachments: attachments,
    );
  }

  // Submission Methods
  Future<void> submitTask(int taskId, List<SubmissionAttachment> attachments) async {
    final formData = FormData.fromMap({
      'attachments': attachments.map((attachment) => MultipartFile.fromBytes(attachment.fileBytes, filename: attachment.fileName)).toList(),
    });

    final response = await dio.post(
      '/task/$taskId/submit',
      data: formData,
      options: Options(
        validateStatus: (status) => status == 200 || status == 400 || status == 401,
        contentType: 'multipart/form-data',
      )
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit task: ${response.statusCode}');
    }
  }

  Future<List<Submission>> fetchTaskSubmissions(int taskId) async {
    final response = await dio.get(
      '/task/$taskId/submissions',
      options: Options(
        validateStatus: (status) => status == 200 || status == 500 || status == 401,
      )
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch submissions: ${response.statusCode}');
    }

    List<dynamic> data = response.data;
    List<Submission> submissions = data.map((submission) {
      List<SubmissionAttachment>? attachments;
      if (submission['attachments'] != null) {
        attachments = (submission['attachments'] as List<dynamic>).map((att) => SubmissionAttachment(
          id: att['id'],
          submissionId: att['submissionId'],
          fileName: att['fileName'].toString(),
          filePath: att['filePath'].toString(),
          fileBytes: List<int>.empty(),
          createdAt: att['createdAt'] != null ? DateTime.parse(att['createdAt']) : null,
          updatedAt: att['updatedAt'] != null ? DateTime.parse(att['updatedAt']) : null,
        )).toList();
      }

      return Submission(
        id: submission['id'],
        taskId: submission['taskId'],
        studentId: submission['studentId'],
        grade: submission['grade']?.toDouble(),
        feedback: submission['feedback'] ?? '',
        hasAttachment: submission['hasAttachment'] ?? false,
        isGraded: submission['graded'] ?? false,
        submittedAt: DateTime.parse(submission['submittedAt'].toString()),
        createdAt: DateTime.parse(submission['createdAt'].toString()),
        updatedAt: DateTime.parse(submission['updatedAt'].toString()),
        attachments: attachments,
      );
    }).toList();

    return submissions;
  }

  Future<void> gradeSubmission(int submissionId, double grade, String feedback) async {
    final response = await dio.post(
      '/task/$submissionId/grade',
      data: {
        'grade': grade,
        'feedback': feedback,
      },
      options: Options(
        validateStatus: (status) => status == 200 || status == 400 || status == 401,
      )
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to grade submission: ${response.statusCode}');
    }
  }

  // User Creation Methods (Students)
  Future<User> createStudent(String name, String email, String password) async {
    final customDio = Dio(BaseOptions(baseUrl: baseUrl));
    final BrowserHttpClientAdapter customHttpClientAdapter = BrowserHttpClientAdapter();
    customHttpClientAdapter.withCredentials = false;
    customDio.httpClientAdapter = customHttpClientAdapter;

    final response = await customDio.post(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'role': 'STUDENT',
      },
      options: Options(
        validateStatus: (status) => status == 201 || status == 400 || status == 401,
      )
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create student: ${response.statusCode}');
    }

    Map<String, dynamic> data = response.data['data'];

    return User(
      id: data['id'],
      name: data['name'].toString(),
      email: data['email'].toString(),
      role: User.roleFromString(data['role'].toString()),
    );
  }

  // File Download Methods
  Future<void> downloadFile(String filename) async {
    final response = await dio.get(
      '/files/download/$filename',
      options: Options(
        responseType: ResponseType.bytes,
      )
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to download file: ${response.statusCode}');
    }
    
    // Handle file download - this would typically save to downloads or open in browser
  }
}
