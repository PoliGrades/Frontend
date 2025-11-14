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
}