import 'dart:io';
import 'dart:convert';

/// Server TCP per il gioco Tris.
/// Accetta due client, li abbina in una stanza e mantiene lo stato della partita.

class GameRoom {
  /// Socket del primo giocatore.
  late Socket player1;

  /// Socket del secondo giocatore.
  late Socket player2;

  /// Griglia del gioco, 9 celle da 0 a 8.
  late List<String> board;

  /// Simbolo del giocatore in turno.
  late String currentPlayer;

  /// Simbolo assegnato al primo giocatore.
  late String player1Symbol;

  /// Simbolo assegnato al secondo giocatore.
  late String player2Symbol;

  /// Indica se la partita è finita.
  late bool gameOver;

  /// Simbolo del vincitore o 'Draw' in caso di pareggio.
  late String winner;

  GameRoom(this.player1, this.player2) {
    board = List.filled(9, '');
    currentPlayer = 'X';
    player1Symbol = 'X';
    player2Symbol = 'O';
    gameOver = false;
    winner = '';
  }

  /// Esegue la mossa sulla posizione specificata e aggiorna lo stato della partita.
  bool makeMove(int position, String symbol) {
    if (board[position].isNotEmpty || gameOver) {
      return false;
    }

    board[position] = symbol;

    // Verifica se la mossa ha portato a una vittoria.
    if (checkWinner(symbol)) {
      gameOver = true;
      winner = symbol;
      return true;
    }

    // Verifica se la griglia è piena: pareggio.
    if (board.every((cell) => cell.isNotEmpty)) {
      gameOver = true;
      winner = 'Draw';
      return true;
    }

    // Cambia il turno del giocatore.
    currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
    return true;
  }

  /// Controlla le combinazioni vincenti per un simbolo.
  bool checkWinner(String symbol) {
    List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningCombinations) {
      if (board[combination[0]] == symbol &&
          board[combination[1]] == symbol &&
          board[combination[2]] == symbol) {
        return true;
      }
    }
    return false;
  }

  /// Restituisce lo stato corrente del gioco come JSON.
  String getBoardState() {
    return jsonEncode({
      'board': board,
      'currentPlayer': currentPlayer,
      'gameOver': gameOver,
      'winner': winner,
    });
  }
}

void main() async {
  final port = 5000;
  final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, port);
  print('Server avviato su porta $port');

  Map<Socket, Socket?> connectedClients = {};
  List<GameRoom> activeGames = [];

  server.listen((Socket client) {
    print('Cliente connesso: ${client.remoteAddress.address}');

    client.listen(
      (data) {
        String message = utf8.decode(data).trim();
        print('Messaggio ricevuto: $message');

        try {
          Map<String, dynamic> request = jsonDecode(message);
          String action = request['action'] ?? '';

          if (action == 'joinGame') {
            // Cerca un giocatore in attesa di essere abbinato.
            Socket? waitingPlayer;
            for (var entry in connectedClients.entries) {
              if (entry.value == null && entry.key != client) {
                waitingPlayer = entry.key;
                break;
              }
            }

            if (waitingPlayer != null) {
              // Crea una nuova stanza di gioco con due giocatori.
              GameRoom room = GameRoom(waitingPlayer, client);
              activeGames.add(room);
              connectedClients[waitingPlayer] = client;
              connectedClients[client] = waitingPlayer;

              // Invia il messaggio di inizio partita a entrambi.
              String gameStartMessage = jsonEncode({
                'type': 'gameStarted',
                'yourSymbol': 'X',
                'opponentSymbol': 'O',
                'board': room.board,
                'currentPlayer': room.currentPlayer,
              });
              waitingPlayer.write('$gameStartMessage\n');

              String gameStartMessage2 = jsonEncode({
                'type': 'gameStarted',
                'yourSymbol': 'O',
                'opponentSymbol': 'X',
                'board': room.board,
                'currentPlayer': room.currentPlayer,
              });
              client.write('$gameStartMessage2\n');
            } else {
              // Nessun avversario subito disponibile: metti il client in attesa.
              connectedClients[client] = null;
              String waitMessage = jsonEncode({
                'type': 'waiting',
                'message': 'In attesa di un avversario...',
              });
              client.write('$waitMessage\n');
            }
          } else if (action == 'makeMove') {
            int position = request['position'] ?? -1;
            Socket? opponent = connectedClients[client];

            if (opponent != null) {
              GameRoom? room;
              for (var r in activeGames) {
                if ((r.player1 == client && r.player2 == opponent) ||
                    (r.player1 == opponent && r.player2 == client)) {
                  room = r;
                  break;
                }
              }

              if (room != null) {
                String playerSymbol = (room.player1 == client)
                    ? room.player1Symbol
                    : room.player2Symbol;

                if (room.currentPlayer == playerSymbol &&
                    position >= 0 &&
                    position < 9) {
                  if (room.makeMove(position, playerSymbol)) {
                    String stateMessage = jsonEncode({
                      'type': 'gameState',
                      'board': room.board,
                      'currentPlayer': room.currentPlayer,
                      'gameOver': room.gameOver,
                      'winner': room.winner,
                    });

                    client.write('$stateMessage\n');
                    opponent.write('$stateMessage\n');
                  } else {
                    String errorMessage = jsonEncode({
                      'type': 'error',
                      'message': 'Mossa non valida',
                    });
                    client.write('$errorMessage\n');
                  }
                } else {
                  String errorMessage = jsonEncode({
                    'type': 'error',
                    'message': 'Non è il tuo turno o posizione non valida',
                  });
                  client.write('$errorMessage\n');
                }
              }
            }
          }
        } catch (e) {
          print('Errore nel processing del messaggio: $e');
          String errorMessage = jsonEncode({
            'type': 'error',
            'message': 'Errore nel server',
          });
          client.write('$errorMessage\n');
        }
      },
      onError: (error) {
        print('Errore dal client: $error');
        Socket? opponent = connectedClients[client];
        if (opponent != null) {
          String disconnectMessage = jsonEncode({
            'type': 'opponentDisconnected',
            'message': "L'avversario si è disconnesso",
          });
          opponent.write('$disconnectMessage\n');
          connectedClients.remove(opponent);
        }
        connectedClients.remove(client);
      },
      onDone: () {
        print('Client disconnesso: ${client.remoteAddress.address}');
        Socket? opponent = connectedClients[client];
        if (opponent != null) {
          String disconnectMessage = jsonEncode({
            'type': 'opponentDisconnected',
            'message': "L'avversario si è disconnesso",
          });
          opponent.write('$disconnectMessage\n');
          connectedClients.remove(opponent);
        }
        connectedClients.remove(client);
      },
    );
  });
}
