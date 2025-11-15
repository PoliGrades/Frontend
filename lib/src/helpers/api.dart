import 'dart:convert';

import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:polieats_frontend/main.dart';
import 'package:polieats_frontend/src/data/Assignments.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Notices.dart';
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
      role: data['role'].toString(),
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
      role: prof['role'].toString(),
    )).toList();

    return professors;
  }

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

      // parse icon string: supports "0x..." hex, plain hex, or decimal codepoint.
      return Course(
        id: int.parse(course['id']?.toString() ?? '0'),
        name: name,
        description: description,
        color: color,
        accentColor: accentColor,
      );
    }).toList();

    return courses;
  }
  
  void createAssignment(String title, String description, DateTime dueDate, int classId, List<Attachment> attachments) async {
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

  Future<List<Assignment>> fetchAssignmentsForSubject(int subjectId) async {
    final response = await dio.get(
      '/tasks/$subjectId',
      options: Options(
        validateStatus: (status) => status == 200 || status == 500 || status == 401,
      )
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch assignments: ${response.statusCode}');
    }

    List<dynamic> data = response.data;
    List<Assignment> assignments = data.map((assignment) {
      // Handle attachments - check if they exist in the response
      List<Attachment> attachments = [];
      if (assignment['attachments'] != null) {
        attachments = (assignment['attachments'] as List<dynamic>).map((att) => Attachment(
          fileName: att['fileName'].toString(),
          filePath: att['filePath'].toString(),
          fileBytes: List<int>.empty(), // Placeholder, actual bytes would need to be fetched separately
        )).toList();
      }

      // Get course name from the course controller using classId
      String courseName = '';
      try {
        final course = globals.courseController.getCourseById(assignment['classId']);
        courseName = course?.name ?? 'Unknown Course';
      } catch (e) {
        courseName = 'Unknown Course';
      }

      return Assignment(
        title: assignment['title'].toString(),
        description: assignment['description'].toString(),
        dueDate: DateTime.parse(assignment['dueDate'].toString()),
        course: courseName,
        attachments: attachments,
      );
    }).toList();

    return assignments;
  }
}