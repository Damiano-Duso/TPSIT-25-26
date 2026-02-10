/// Configurazione dell'applicazione Tris Online

// CONFIGURAZIONE DEL SERVER

/// Porta su cui il server TCP ascolta
const int SERVER_PORT = 5000;

/// Indirizzo IP su cui il server ascolta (0.0.0.0 = tutte le interfacce)
const String SERVER_HOST = '0.0.0.0';

/// Timeout di inattività della connessione (secondi)
const int CONNECTION_TIMEOUT = 300; // 5 minuti

// CONFIGURAZIONE DEL CLIENT FLUTTER

/// Timeout per la connessione al server (secondi)
const int CLIENT_CONNECT_TIMEOUT = 10;

/// Host di default per il server (localhost per sviluppo)
const String DEFAULT_SERVER_HOST = 'localhost';

/// Porta di default del server
const int DEFAULT_SERVER_PORT = 5000;

// CONFIGURAZIONE DEL GIOCO

/// Dimensione della griglia (3x3 per Tris)
const int GRID_SIZE = 3;

/// Numero totale di celle
const int TOTAL_CELLS = GRID_SIZE * GRID_SIZE;

/// Simbolo del primo giocatore
const String SYMBOL_PLAYER_1 = 'X';

/// Simbolo del secondo giocatore
const String SYMBOL_PLAYER_2 = 'O';

// CONFIGURAZIONE UI

/// Colore primario dell'app
const String PRIMARY_COLOR = '0xFF7C3AED'; // Deep Purple

/// Colore del simbolo X
const String COLOR_X = '0xFFEF4444'; // Red

/// Colore del simbolo O
const String COLOR_O = '0xFF3B82F6'; // Blue

/// Spaziatura tra gli elementi
const double SPACING_SMALL = 8.0;
const double SPACING_MEDIUM = 16.0;
const double SPACING_LARGE = 24.0;

// MESSAGGI

const String MSG_WAITING = 'In attesa di un avversario...';
const String MSG_YOUR_TURN = 'Il tuo turno!';
const String MSG_OPPONENT_TURN = 'Turno dell\'avversario';
const String MSG_YOU_WON = 'Hai vinto! 🎉';
const String MSG_YOU_LOST = 'Hai perso';
const String MSG_DRAW = 'Pareggio!';
const String MSG_OPPONENT_DISCONNECTED = 'L\'avversario si è disconnesso';
const String MSG_CONNECTION_ERROR = 'Errore di connessione al server';
const String MSG_INVALID_MOVE = 'Mossa non valida';

// VINCITE


/// Combinazioni vincenti nel Tris (indici della griglia 0-8)
const List<List<int>> WINNING_COMBINATIONS = [
  // Righe
  [0, 1, 2],
  [3, 4, 5],
  [6, 7, 8],
  // Colonne
  [0, 3, 6],
  [1, 4, 7],
  [2, 5, 8],
  // Diagonali
  [0, 4, 8],
  [2, 4, 6],
];



/// Abilita il logging verbose
const bool DEBUG_MODE = false;

/// Abilita il logging delle mosse
const bool DEBUG_MOVES = false;

/// Abilita il logging della comunicazione
const bool DEBUG_NETWORK = false;

/// Abilita la funzionalità di revert della mossa (non implementata)
const bool ENABLE_UNDO = false;

/// Abilita la chat tra giocatori (non implementata)
const bool ENABLE_CHAT = false;

/// Abilita le statistiche (non implementata)
const bool ENABLE_STATS = false;

/// Abilita le partite salvate (non implementata)
const bool ENABLE_SAVED_GAMES = false;
