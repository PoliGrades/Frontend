import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import 'package:http/http.dart' as http;

class SocketService {
  SocketService._internal();
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  IO.Socket? _socket;

  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  bool get connected => _socket?.connected ?? false;

  void connect(
    String url, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    if (_socket != null && _socket!.connected) return;
    _socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .setExtraHeaders(Map<String, dynamic>.from(headers ?? {}))
          .setQuery(Map<String, dynamic>.from(query ?? {}))
          .build(),
    );

    _socket!
      ..onConnect((_) {
        print('Socket conectado => $url');
      })
      ..onConnectError((data) {
        print('Socket erro de conexão: $data');
      })
      ..onError((err) {
        print('Socket erro: $err');
      })
      ..onDisconnect((_) {
        print('Socket desconectado');
      })
      ..on('message', (data) {
        // message: { type: 'message', data: <message> }
        if (data is Map) {
          _messageController.add({
            'type': 'message',
            'data': Map<String, dynamic>.from(data),
          });
        } else {
          _messageController.add({
            'type': 'message',
            'data': {'text': data.toString()},
          });
        }
      })
      // Mensagens anteriores ao entrar no chat
      ..on('previousMessages', (data) {
        if (data is List) {
          _messageController.add({'type': 'previousMessages', 'data': data});
        } else {
          _messageController.add({
            'type': 'previousMessages',
            'data': [data],
          });
        }
      })
      // Confirmação de entrada no chat
      ..on('joinedChat', (data) {
        _messageController.add({'type': 'joinedChat', 'data': data});
      });
  }

  void connectToAuthLogin({
    String baseUrl = 'https://api.poligrades.matelz.dev',
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    final nsUrl = baseUrl.endsWith('/')
        ? '${baseUrl}auth/login'
        : '$baseUrl/auth/login';
    connect(nsUrl, query: query, headers: headers);
  }

  void emit(String event, dynamic data) {
    if (_socket == null) {
      print('Socket não inicializado. Chame connect() primeiro.');
      return;
    }
    _socket!.emit(event, data);
  }

  void joinChat(String professorId) {
    if (_socket == null) return;
    _socket!.emit('joinChat', professorId);
  }

  void sendMessage({required String professorId, required String message}) {
    if (_socket == null) return;
    final payload = {'professorID': professorId, 'message': message};
    _socket!.emit('sendMessage', payload);
  }

  void on(String event, Function(dynamic) handler) {
    _socket?.on(event, handler);
  }

  void off(String event) {
    _socket?.off(event);
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.destroy();
    _socket = null;
  }

  // Dispose
  Future<void> dispose() async {
    disconnect();
    await _messageController.close();
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final resp = await http.post(
      Uri.parse('https://api.poligrades.matelz.dev/auth/login'),
      body: {'email': email, 'password': password},
    );
    final setCookie = resp.headers['set-cookie'];

    Map<String, dynamic> body = {};
    try {
      if (resp.body.isNotEmpty)
        body = jsonDecode(resp.body) as Map<String, dynamic>;
    } catch (_) {}

    return {
      'setCookie': setCookie,
      'body': body,
      'statusCode': resp.statusCode,
    };
  }

  Future<void> loginAndConnect(String email, String password) async {
    final result = await login(email, password);
    final setCookie = result['setCookie'] as String?;
    if (setCookie == null) {
      throw StateError('No set-cookie returned from login');
    }

    connect(
      'https://api.poligrades.matelz.dev',
      headers: {'cookie': setCookie},
    );
  }
}
