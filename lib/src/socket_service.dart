import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  late Socket socket;

  Socket get getSocket => socket;

  bool isConnected() => socket.connected;

  connect() {
    socket.connect();
  }

  addListener(String eventName, Function(dynamic) callback) {
    socket.on(eventName, callback);
  }

  emit(String eventName, List<dynamic> args) {
    socket.emit(eventName, args);
  }

  SocketService() {
    socket = io('http://localhost:3000', OptionBuilder()
      .setTransports(['websocket']) // for Flutter or Dart VM
      .disableAutoConnect()
      .build());

    socket.io.options?['extraHeaders'] = {
      'Authorization': 'Bearer 1234567890abcdef',
    };
  }
}