import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:polieats_frontend/main.dart';
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
    
    currentUser = User(
      email: data['email'].toString(),
      name: data['name'].toString(),
      id: data['id'],
      role: data['role'].toString(),
    );

    return currentUser;
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
}