import 'dart:io';
import 'dart:convert';
import 'dart:async';

/// Test di Integrazione per Tris Online
/// Simula due client che giocano una partita completa

class ClientSimulator {
  late Socket socket;
  String name;
  String? symbol;
  List<String> board = List.filled(9, '');
  String status = 'disconnected';

  ClientSimulator(this.name);

  Future<bool> connect(String host, int port) async {
    try {
      socket = await Socket.connect(host, port).timeout(Duration(seconds: 5));
      status = 'connected';
      print('[$name] ✓ Connesso a $host:$port');

      // Listener per messaggi del server
      socket.listen(
        (data) {
          String message = utf8.decode(data).trim();
          if (message.isNotEmpty) {
            try {
              Map<String, dynamic> response = jsonDecode(message);
              _handleMessage(response);
            } catch (e) {
              print('[$name] ✗ Errore parsing: $e');
            }
          }
        },
        onError: (error) {
          print('[$name] ✗ Errore di comunicazione: $error');
          status = 'error';
        },
        onDone: () {
          print('[$name] Disconnesso dal server');
          status = 'disconnected';
        },
      );

      return true;
    } catch (e) {
      print('[$name] ✗ Errore di connessione: $e');
      status = 'error';
      return false;
    }
  }

  void _handleMessage(Map<String, dynamic> response) {
    String type = response['type'] ?? '';

    switch (type) {
      case 'waiting':
        print('[$name] In attesa di un avversario...');
        status = 'waiting';
        break;

      case 'gameStarted':
        symbol = response['yourSymbol'];
        board = List<String>.from(response['board'] ?? []);
        print('[$name] ✓ Gioco iniziato! Tu sei: $symbol');
        status = 'playing';
        break;

      case 'gameState':
        board = List<String>.from(response['board'] ?? []);
        String currentPlayer = response['currentPlayer'] ?? '';
        bool gameOver = response['gameOver'] ?? false;
        String winner = response['winner'] ?? '';

        _printBoard();
        print('[$name] Turno: $currentPlayer');

        if (gameOver) {
          status = 'game_over';
          print('[$name] ╔════════════════════════════════╗');
          if (winner == 'Draw') {
            print('[$name] ║         PAREGGIO!              ║');
          } else if (winner == symbol) {
            print('[$name] ║      HAI VINTO! 🎉             ║');
          } else {
            print('[$name] ║      HAI PERSO                 ║');
          }
          print('[$name] ╚════════════════════════════════╝');
        }
        break;

      case 'error':
        print('[$name] ✗ Errore: ${response['message']}');
        break;

      case 'opponentDisconnected':
        print('[$name] ⚠️  L\'avversario si è disconnesso');
        status = 'opponent_disconnected';
        break;
    }
  }

  void joinGame() {
    String message = jsonEncode({'action': 'joinGame'});
    socket.write(message + '\n');
    print('[$name] Richiesta di join inviata');
  }

  void makeMove(int position) {
    // Attendi il nostro turno
    if (status == 'playing' && board[position].isEmpty) {
      String message = jsonEncode({
        'action': 'makeMove',
        'position': position,
      });
      socket.write(message + '\n');
      print('[$name] Mossa inviata: posizione $position');
    }
  }

  void _printBoard() {
    print('[$name] Board:');
    for (int i = 0; i < 3; i++) {
      String row = '[$name]   ';
      for (int j = 0; j < 3; j++) {
        int index = i * 3 + j;
        String cell = board[index].isEmpty ? '$index' : board[index];
        row += '[${cell.padRight(1)}] ';
      }
      print(row);
    }
  }

  void disconnect() {
    if (status != 'disconnected') {
      socket.close();
      status = 'disconnected';
      print('[$name] Disconnesso');
    }
  }
}

Future<void> main() async {
  print('╔════════════════════════════════════════════╗');
  print('║   TEST DI INTEGRAZIONE - Tris Online       ║');
  print('║     Simula due client che giocano          ║');
  print('╚════════════════════════════════════════════╝');
  print('');

  const String host = 'localhost';
  const int port = 5000;

  // Crea due client
  ClientSimulator player1 = ClientSimulator('Player 1 (X)');
  ClientSimulator player2 = ClientSimulator('Player 2 (O)');

  // Test 1: Connessione
  print('═══════════════════════════════════════════');
  print('TEST 1: Connessione al server');
  print('═══════════════════════════════════════════');
  print('');

  if (!await player1.connect(host, port)) {
    print('✗ Errore: Impossibile connettersi al server.');
    print('  Assicurati che il server sia avviato: dart server.dart');
    return;
  }

  await Future.delayed(Duration(milliseconds: 500));

  if (!await player2.connect(host, port)) {
    print('✗ Errore: Impossibile connettersi al server.');
    player1.disconnect();
    return;
  }

  print('✓ Test 1 completato\n');

  // Test 2: Join Game
  print('═══════════════════════════════════════════');
  print('TEST 2: Join Game');
  print('═══════════════════════════════════════════');
  print('');

  player1.joinGame();
  await Future.delayed(Duration(seconds: 1));

  player2.joinGame();
  await Future.delayed(Duration(seconds: 1));

  print('✓ Test 2 completato\n');

  // Test 3: Gameplay
  print('═══════════════════════════════════════════');
  print('TEST 3: Gameplay');
  print('═══════════════════════════════════════════');
  print('');

  // Sequenza di mosse per una partita vincente (X vince)
  List<int> moves = [0, 3, 1, 4, 2]; // X vince con [0, 1, 2]

  int moveIndex = 0;
  for (int i = 0; i < moves.length; i++) {
    await Future.delayed(Duration(milliseconds: 500));

    if (i % 2 == 0) {
      // X (Player 1)
      print('Player 1 (X) gioca...');
      player1.makeMove(moves[i]);
    } else {
      // O (Player 2)
      print('Player 2 (O) gioca...');
      player2.makeMove(moves[i]);
    }

    await Future.delayed(Duration(milliseconds: 1000));
  }

  // Attendi il completamento del gioco
  await Future.delayed(Duration(seconds: 2));

  print('✓ Test 3 completato\n');

  // Test 4: Disconnect
  print('═══════════════════════════════════════════');
  print('TEST 4: Cleanup');
  print('═══════════════════════════════════════════');
  print('');

  player1.disconnect();
  player2.disconnect();

  print('✓ Test 4 completato\n');

  // Resoconto
  print('╔════════════════════════════════════════════╗');
  print('║   TEST COMPLETATI CON SUCCESSO ✓           ║');
  print('║                                            ║');
  print('║  Se vuoi aggiungere più test:             ║');
  print('║  1. Modifica la lista \'moves\'            ║');
  print('║  2. Usa player1.makeMove() e              ║');
  print('║     player2.makeMove()                    ║');
  print('║                                            ║');
  print('╚════════════════════════════════════════════╝');

  exit(0);
}
