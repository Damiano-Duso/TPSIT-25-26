import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../services/game_service.dart';

class GameScreen extends StatefulWidget {
  final GameService gameService;
  final String serverHost;
  final int serverPort;

  const GameScreen({
    Key? key,
    required this.gameService,
    required this.serverHost,
    required this.serverPort,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late TicTacToeGame game;
  String statusMessage = 'In connessione...';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    game = TicTacToeGame();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    widget.gameService.onMessageReceived = _handleServerMessage;
    bool connected = await widget.gameService.connect();

    if (connected) {
      widget.gameService.joinGame();
    } else {
      if (mounted) {
        setState(() {
          statusMessage = 'Errore di connessione al server';
          isLoading = false;
        });
      }
    }
  }

  void _handleServerMessage(Map<String, dynamic> message) {
    String type = message['type'] ?? '';

    setState(() {
      switch (type) {
        case 'gameStarted':
          game.yourSymbol = message['yourSymbol'];
          game.opponentSymbol = message['opponentSymbol'];
          game.currentPlayer = message['currentPlayer'];
          game.board = List<String>.from(message['board'] ?? []);
          statusMessage = game.getStatusMessage();
          isLoading = false;
          break;

        case 'gameState':
          game.updateFromServer(message);
          statusMessage = game.getStatusMessage();
          break;

        case 'waiting':
          statusMessage = message['message'] ?? 'In attesa...';
          isLoading = false;
          break;

        case 'error':
          statusMessage = 'Errore: ${message['message']}';
          break;

        case 'opponentDisconnected':
          statusMessage = "L'avversario si è disconnesso";
          game.gameOver = true;
          break;
      }
    });
  }

  void _onCellTapped(int index) {
    if (game.isValidMove(index) && game.canMove()) {
      widget.gameService.makeMove(index);
    }
  }

  void _resetGame() {
    widget.gameService.disconnect();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    widget.gameService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tris Online'),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(statusMessage),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Header con informazioni di gioco
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Tu: ${game.yourSymbol ?? '?'} vs Avversario: ${game.opponentSymbol ?? '?'}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        statusMessage,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: game.canMove()
                              ? Colors.green
                              : (game.gameOver ? Colors.red : Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),

                // Griglia di gioco
                Expanded(
                  child: Center(
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _onCellTapped(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              border: Border.all(
                                color: Colors.blue,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                game.board[index],
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: game.board[index] == 'X'
                                      ? Colors.red
                                      : Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Pulsanti di azione
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      if (game.gameOver)
                        ElevatedButton(
                          onPressed: _resetGame,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                          ),
                          child: const Text(
                            'Torna alla Home',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _resetGame,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                        ),
                        child: const Text(
                          'Esci dal gioco',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
