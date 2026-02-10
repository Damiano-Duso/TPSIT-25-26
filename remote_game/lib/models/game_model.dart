/// Modello del gioco Tris
class TicTacToeGame {
  List<String> board;
  String currentPlayer;
  bool gameOver;
  String winner;
  String? yourSymbol;
  String? opponentSymbol;

  TicTacToeGame({
    List<String>? initialBoard,
    this.currentPlayer = 'X',
    this.gameOver = false,
    this.winner = '',
    this.yourSymbol,
    this.opponentSymbol,
  }) : board = initialBoard ?? List.filled(9, '');

  void updateFromServer(Map<String, dynamic> state) {
    board = List<String>.from(state['board'] ?? board);
    currentPlayer = state['currentPlayer'] ?? currentPlayer;
    gameOver = state['gameOver'] ?? false;
    winner = state['winner'] ?? '';
  }

  bool isValidMove(int position) {
    return position >= 0 && position < 9 && board[position].isEmpty;
  }

  bool canMove() {
    return !gameOver && currentPlayer == yourSymbol;
  }

  String getStatusMessage() {
    if (!gameOver) {
      if (currentPlayer == yourSymbol) {
        return 'Il tuo turno!';
      } else {
        return "Turno dell'avversario";
      }
    } else if (winner == 'Draw') {
      return 'Pareggio!';
    } else if (winner == yourSymbol) {
      return 'Hai vinto! 🎉';
    } else {
      return 'Hai perso';
    }
  }
}
