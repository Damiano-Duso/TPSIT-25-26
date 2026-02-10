import 'dart:async';
import 'dart:io';
import 'dart:convert';

/// Server per il gioco del Tris a distanza
/// Accetta connessioni da due client e gestisce la logica del gioco

class GameRoom {
  late Socket player1;
  late Socket player2;
  late List<String> board; // 0-8 per le 9 celle
  late String currentPlayer; // 'X' o 'O'
  late String player1Symbol; // 'X' o 'O'
  late String player2Symbol;
  late bool gameOver;
  late String winner;

  GameRoom(this.player1, this.player2) {
    board = List.filled(9, '');
    currentPlayer = 'X';
    player1Symbol = 'X';
    player2Symbol = 'O';
    gameOver = false;
    winner = '';
  }

  bool makeMove(int position, String symbol) {
    if (board[position].isNotEmpty || gameOver) {
      return false;
    }

    board[position] = symbol;

    // Verifica se c'è un vincitore
    if (checkWinner(symbol)) {
      gameOver = true;
      winner = symbol;
      return true;
    }

    // Verifica se è un pareggio
    if (board.every((cell) => cell.isNotEmpty)) {
      gameOver = true;
      winner = 'Draw';
      return true;
    }

    // Cambia turno
    currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
    return true;
  }

  bool checkWinner(String symbol) {
    // Combinazioni vincenti
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
            // Controlla se c'è un giocatore in attesa
            Socket? waitingPlayer;
            for (var entry in connectedClients.entries) {
              if (entry.value == null && entry.key != client) {
                waitingPlayer = entry.key;
                break;
              }
            }

            if (waitingPlayer != null) {
              // Crea una nuova stanza di gioco
              GameRoom room = GameRoom(waitingPlayer, client);
              activeGames.add(room);
              connectedClients[waitingPlayer] = client;
              connectedClients[client] = waitingPlayer;

              // Notifica entrambi i giocatori che il gioco è iniziato
              String gameStartMessage = jsonEncode({
                'type': 'gameStarted',
                'yourSymbol': 'X',
                'opponentSymbol': 'O',
                'board': room.board,
                'currentPlayer': room.currentPlayer,
              });
              waitingPlayer.write(gameStartMessage + '\n');

              String gameStartMessage2 = jsonEncode({
                'type': 'gameStarted',
                'yourSymbol': 'O',
                'opponentSymbol': 'X',
                'board': room.board,
                'currentPlayer': room.currentPlayer,
              });
              client.write(gameStartMessage2 + '\n');
            } else {
              // Questo giocatore aspetta un avversario
              connectedClients[client] = null;
              String waitMessage = jsonEncode({
                'type': 'waiting',
                'message': 'In attesa di un avversario...',
              });
              client.write(waitMessage + '\n');
            }
          } else if (action == 'makeMove') {
            int position = request['position'] ?? -1;
            Socket? opponent = connectedClients[client];

            if (opponent != null) {
              // Trova la stanza di gioco
              GameRoom? room;
              for (var r in activeGames) {
                if ((r.player1 == client && r.player2 == opponent) ||
                    (r.player1 == opponent && r.player2 == client)) {
                  room = r;
                  break;
                }
              }

              if (room != null) {
                String playerSymbol =
                    (room.player1 == client) ? room.player1Symbol : room.player2Symbol;

                if (room.currentPlayer == playerSymbol && position >= 0 && position < 9) {
                  if (room.makeMove(position, playerSymbol)) {
                    // Invia lo stato del gioco aggiornato a entrambi i giocatori
                    String stateMessage = jsonEncode({
                      'type': 'gameState',
                      'board': room.board,
                      'currentPlayer': room.currentPlayer,
                      'gameOver': room.gameOver,
                      'winner': room.winner,
                    });

                    client.write(stateMessage + '\n');
                    opponent.write(stateMessage + '\n');
                  } else {
                    // Mossa non valida
                    String errorMessage = jsonEncode({
                      'type': 'error',
                      'message': 'Mossa non valida',
                    });
                    client.write(errorMessage + '\n');
                  }
                } else {
                  // Non è il turno di questo giocatore o posizione non valida
                  String errorMessage = jsonEncode({
                    'type': 'error',
                    'message': 'Non è il tuo turno o posizione non valida',
                  });
                  client.write(errorMessage + '\n');
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
          client.write(errorMessage + '\n');
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
          opponent.write(disconnectMessage + '\n');
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
          opponent.write(disconnectMessage + '\n');
          connectedClients.remove(opponent);
        }
        connectedClients.remove(client);
      },
    );
  });
}
