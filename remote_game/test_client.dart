import 'dart:io';
import 'dart:convert';

/// Script di test per verificare la comunicazione con il server Tris

Future<void> main() async {
  print('╔════════════════════════════════════════╗');
  print('║   Tris Online - Client Test Script     ║');
  print('╚════════════════════════════════════════╝');
  print('');

  // Parametri del server
  const String serverHost = 'localhost';
  const int serverPort = 5000;

  // Test 1: Connessione al server
  print('Test 1: Connessione al server...');
  Socket? socket;

  try {
    socket = await Socket.connect(serverHost, serverPort).timeout(
      Duration(seconds: 5),
    );
    print('✓ Connesso al server');
  } catch (e) {
    print('✗ Errore di connessione: $e');
    print('  Assicurati che il server sia avviato: dart server.dart');
    return;
  }

  print('');

  // Test 2: Invio del comando joinGame
  print('Test 2: Invio comando joinGame...');

  String joinMessage = jsonEncode({'action': 'joinGame'});
  socket.write(joinMessage + '\n');
  print('✓ Messaggio inviato: $joinMessage');

  print('');

  // Test 3: Ricezione della risposta
  print('Test 3: Attesa della risposta dal server...');
  print('');

  bool receivedResponse = false;

  socket.listen(
    (data) {
      String message = utf8.decode(data).trim();

      if (message.isNotEmpty) {
        receivedResponse = true;

        try {
          Map<String, dynamic> response = jsonDecode(message);
          String type = response['type'] ?? 'unknown';

          print('✓ Risposta ricevuta:');
          print('  Type: $type');

          if (type == 'waiting') {
            print('  Message: ${response['message']}');
            print('');
            print('  Il server è in attesa di un secondo giocatore.');
            print('  Avvia un secondo client per iniziare il gioco!');
          } else if (type == 'gameStarted') {
            print('  Your Symbol: ${response['yourSymbol']}');
            print('  Opponent Symbol: ${response['opponentSymbol']}');
            print('  Current Player: ${response['currentPlayer']}');

            // Simulare una mossa
            print('');
            print('Test 4: Invio di una mossa...');
            String moveMessage = jsonEncode({
              'action': 'makeMove',
              'position': 4,
            });
            socket.write(moveMessage + '\n');
            print('✓ Mossa inviata: posizione 4');
          } else if (type == 'gameState') {
            print('  Board: ${response['board']}');
            print('  Current Player: ${response['currentPlayer']}');
            print('  Game Over: ${response['gameOver']}');
            print('  Winner: ${response['winner']}');
          } else if (type == 'error') {
            print('  Error: ${response['message']}');
          }

          print('');
          print('╔════════════════════════════════════════╗');
          print('║         Test Completato ✓              ║');
          print('╚════════════════════════════════════════╝');

          socket.close();
        } catch (e) {
          print('✗ Errore nel parsing della risposta: $e');
          print('  Risposta ricevuta: $message');
          socket.close();
        }
      }
    },
    onError: (error) {
      print('✗ Errore di comunicazione: $error');
      socket.close();
    },
    onDone: () {
      if (!receivedResponse) {
        print('✗ Disconnesso dal server senza ricevere risposta');
      }
    },
  );

  // Timeout
  await Future.delayed(Duration(seconds: 10));
  if (!receivedResponse) {
    print('✗ Timeout: nessuna risposta dal server entro 10 secondi');
  }

  socket.close();
}
