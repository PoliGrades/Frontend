import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:polieats_frontend/main.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Notices.dart';
import 'package:polieats_frontend/src/data/User.dart';

class Api {
  final String baseUrl = 'https://api.poligrades.matelz.dev';
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
      '/notices',
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
      content: notice['content'].toString(),
      date: DateTime.parse(notice['date'].toString()),
      course: notice['className'].toString(),
      owner: notice['userName'].toString()
    )).toList();

    return notices;
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
        name: name,
        description: description,
        color: color,
        accentColor: accentColor,
      );
    }).toList();

    return courses;
  }
}