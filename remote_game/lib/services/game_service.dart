import 'dart:io';
import 'dart:convert';

/// Service per la comunicazione con il server TCP
class GameService {
  late Socket _socket;
  final String host;
  final int port;
  bool _isConnected = false;
  late Function(Map<String, dynamic>) onMessageReceived;

  GameService({required this.host, required this.port});

  Future<bool> connect() async {
    try {
      _socket = await Socket.connect(host, port);
      _isConnected = true;
      print('Connesso al server: $host:$port');

      // Ascolta i messaggi dal server
      _socket.listen(
        (data) {
          String message = utf8.decode(data).trim();
          if (message.isNotEmpty) {
            try {
              Map<String, dynamic> decoded = jsonDecode(message);
              onMessageReceived(decoded);
            } catch (e) {
              print('Errore nel decoding del messaggio: $e');
            }
          }
        },
        onError: (error) {
          print('Errore di comunicazione: $error');
          _isConnected = false;
        },
        onDone: () {
          print('Disconnesso dal server');
          _isConnected = false;
        },
      );

      return true;
    } catch (e) {
      print('Errore di connessione: $e');
      _isConnected = false;
      return false;
    }
  }

  bool get isConnected => _isConnected;

  void joinGame() {
    if (_isConnected) {
      String request = jsonEncode({
        'action': 'joinGame',
      });
      _socket.write(request + '\n');
    }
  }

  void makeMove(int position) {
    if (_isConnected) {
      String request = jsonEncode({
        'action': 'makeMove',
        'position': position,
      });
      _socket.write(request + '\n');
    }
  }

  void disconnect() {
    if (_isConnected) {
      _socket.close();
      _isConnected = false;
    }
  }
}
