import 'dart:io';
import 'dart:convert';

/// Servizio che gestisce la connessione TCP con il server di gioco.
/// Invia richieste JSON e riceve messaggi dal server.
class GameService {
  late Socket _socket;
  final String host;
  final int port;

  /// Flag che indica se la connessione è attiva.
  bool _isConnected = false;

  /// Funzione callback chiamata quando arriva un messaggio dal server.
  late Function(Map<String, dynamic>) onMessageReceived;

  GameService({required this.host, required this.port});

  /// Prova a connettersi al server TCP.
  /// Restituisce true se la connessione è stata stabilita.
  Future<bool> connect() async {
    try {
      _socket = await Socket.connect(host, port);
      _isConnected = true;
      print('Connesso al server: $host:$port');

      // Ascolta i messaggi in arrivo dal server.
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

  /// Invia la richiesta al server per unirsi a una partita.
  void joinGame() {
    if (_isConnected) {
      String request = jsonEncode({'action': 'joinGame'});
      _socket.write('$request\n');
    }
  }

  /// Invia al server la mossa selezionata dall'utente.
  void makeMove(int position) {
    if (_isConnected) {
      String request = jsonEncode({'action': 'makeMove', 'position': position});
      _socket.write('$request\n');
    }
  }

  /// Chiude la connessione con il server.
  void disconnect() {
    if (_isConnected) {
      _socket.close();
      _isConnected = false;
    }
  }
}
