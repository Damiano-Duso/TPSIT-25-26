/// Modello che rappresenta lo stato di una partita di Tris.
/// Contiene la griglia, il turno corrente e l'esito della partita.
class TicTacToeGame {
  /// Stato delle 9 celle della griglia: '', 'X' o 'O'.
  List<String> board;

  /// Simbolo del giocatore che deve muovere ora.
  String currentPlayer;

  /// Indica se la partita è terminata.
  bool gameOver;

  /// Simbolo del vincitore oppure 'Draw' in caso di pareggio.
  String winner;

  /// Simbolo assegnato al giocatore locale.
  String? yourSymbol;

  /// Simbolo dell'avversario.
  String? opponentSymbol;

  TicTacToeGame({
    List<String>? initialBoard,
    this.currentPlayer = 'X',
    this.gameOver = false,
    this.winner = '',
    this.yourSymbol,
    this.opponentSymbol,
  }) : board = initialBoard ?? List.filled(9, '');

  /// Aggiorna lo stato del gioco a partire dai dati ricevuti dal server.
  void updateFromServer(Map<String, dynamic> state) {
    board = List<String>.from(state['board'] ?? board);
    currentPlayer = state['currentPlayer'] ?? currentPlayer;
    gameOver = state['gameOver'] ?? false;
    winner = state['winner'] ?? '';
  }

  /// Controlla se una mossa è valida (indice nella griglia e cella libera).
  bool isValidMove(int position) {
    return position >= 0 && position < 9 && board[position].isEmpty;
  }

  /// Restituisce true se il giocatore locale può muovere.
  bool canMove() {
    return !gameOver && currentPlayer == yourSymbol;
  }

  /// Restituisce il messaggio di stato da mostrare all'utente.
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
