# Architettura Progetto - Tris Online

## Panoramica

Applicazione mobile per giocare a Tris a distanza tra due utenti tramite comunicazione socket TCP.

```
┌─────────────────────────────────────────────────────────────┐
│                    CLIENT FLUTTER                           │
│  ┌────────────────────────────────────────────────────────┐ │
│  │              Schermata di Connessione                  │ │
│  │  Input: Server IP, Porta                              │ │
│  └──────────────┬─────────────────────────────────────────┘ │
│                 │                                            │
│  ┌──────────────▼─────────────────────────────────────────┐ │
│  │           Schermata di Gioco                           │ │
│  │  - Griglia 3x3                                        │ │
│  │  - Visualizzazione stato                              │ │
│  │  - Gestione turni                                     │ │
│  └──────────────┬─────────────────────────────────────────┘ │
│                 │                                            │
│  ┌──────────────▼─────────────────────────────────────────┐ │
│  │         GameService (TCP Socket)                      │ │
│  │  - Connessione al server                              │ │
│  │  - Invio mosse (JSON)                                 │ │
│  │  - Ricezione aggiornamenti (JSON)                     │ │
│  └──────────────┬─────────────────────────────────────────┘ │
└─────────────────┼──────────────────────────────────────────┘
                  │ TCP Socket
        ┌─────────▼──────────┐
        │  Server Dart       │
        │  (Port 5000)       │
        └────────┬───────────┘
                 │
        ┌────────▼───────────┐
        │  GameRoom Manager  │
        │  - Logic Tris      │
        │  - Gestione turni  │
        │  - Check vittoria  │
        └────────┬───────────┘
                 │
        ┌────────▼───────────┐
        │  CLIENT 1 (X)      │
        │  CLIENT 2 (O)      │
        └────────────────────┘
```

---

## Struttura dei File

### 📁 Root Directory

```
remote_game/
├── server.dart           # Server TCP principale
├── test_client.dart      # Client di test Dart
├── run_server.sh         # Script per avviare server (Linux/Mac)
├── run_server.bat        # Script per avviare server (Windows)
├── pubspec.yaml          # Dipendenze Flutter
├── pubspec.lock          # Lock file (generato)
├── README.md             # Documentazione principale
├── QUICKSTART.md         # Guida rapida
├── PROTOCOLLO.md         # Protocollo di comunicazione
├── DEPLOYMENT.md         # Guida deployment
└── ARCHITETTURA.md       # Questo file
```

### 📁 lib/ - Codice Flutter

```
lib/
├── main.dart                 # Entry point
│   └── Classe: MyApp
│       - Theme Material3
│       - Route: ConnectionScreen
│
├── models/
│   └── game_model.dart       # Modello di gioco
│       └── Classe: TicTacToeGame
│           - board: List<String>
│           - currentPlayer: String
│           - gameOver: bool
│           - winner: String
│           - yourSymbol: String?
│           - opponentSymbol: String?
│           - Metodi:
│             * updateFromServer()
│             * isValidMove()
│             * canMove()
│             * getStatusMessage()
│
├── services/
│   └── game_service.dart     # Servizio TCP
│       └── Classe: GameService
│           - host: String
│           - port: int
│           - _socket: Socket
│           - _isConnected: bool
│           - Metodi:
│             * connect()
│             * joinGame()
│             * makeMove()
│             * disconnect()
│
└── screens/
    ├── connection_screen.dart # Schermata di connessione
    │   └── Classe: ConnectionScreen
    │       - Input: host, port
    │       - Pulsante: Connetti al Server
    │       - Mostra: Istruzioni di gioco
    │
    └── game_screen.dart       # Schermata di gioco
        └── Classe: GameScreen
            - Griglia 3x3 interattiva
            - Mostra: Turno, simboli, stato
            - Pulsante: Esci dal gioco
```

---

## Flusso di Dati

### Connessione Iniziale

```
1. User apre l'app
   ↓
2. ConnectionScreen visualizzata
   ↓
3. User inserisce Server IP e Porta
   ↓
4. User click "Connetti al Server"
   ↓
5. GameService.connect() → Socket.connect()
   ↓
6. ConnectionScreen naviga a GameScreen
   ↓
7. GameService.joinGame() → Invia {"action": "joinGame"}
   ↓
8. Server riceve, verifica se c'è un avversario
   ↓
9. Se sì: Invia "gameStarted" a entrambi
   Se no: Invia "waiting" al client
```

### Durante il Gioco

```
1. Player fa click su una cella
   ↓
2. GameScreen._onCellTapped(index)
   ↓
3. Valida mossa: game.isValidMove(index)
   ↓
4. Se valida: GameService.makeMove(index)
   ↓
5. Client invia: {"action": "makeMove", "position": index}
   ↓
6. Server riceve, valida, aggiorna GameRoom
   ↓
7. Server invia: {"type": "gameState", board: [...], ...}
   ↓
8. Client riceve via listener
   ↓
9. GameService.onMessageReceived() viene chiamato
   ↓
10. GameScreen._handleServerMessage() aggiorna UI
    ↓
11. setState() rebuilda la griglia
```

---

## Comunicazione Client-Server

### Formato Messaggi (JSON)

```
CLIENT → SERVER:
  {"action": "joinGame"}
  {"action": "makeMove", "position": 4}

SERVER → CLIENT:
  {"type": "waiting", "message": "..."}
  {"type": "gameStarted", "yourSymbol": "X", "board": [...], ...}
  {"type": "gameState", "board": [...], "currentPlayer": "O", "gameOver": false, "winner": ""}
  {"type": "error", "message": "..."}
  {"type": "opponentDisconnected", "message": "..."}
```

### Socket e Threading

```
Server (Dart):
├── Main Thread
│   └── ServerSocket.bind()
│       └── Ascolta connessioni in loop
│           ├── Crea nuovo thread per ogni client
│           └── Thread client:
│               ├── socket.listen()
│               ├── onData: Processa messaggi JSON
│               ├── onError: Gestisce errori
│               └── onDone: Pulizia risorse

Client (Flutter):
├── Main Thread (UI)
│   └── GameService
│       └── Socket.listen() (asincrono)
│           ├── onData: onMessageReceived()
│           ├── setState() → Rebuild UI
│           └── onError/onDone: Gestione disconnessione
```

---

## Logica del Gioco

### Stato della Griglia

```
Array di 9 elementi [0-8]:
  [0] [1] [2]
  [3] [4] [5]
  [6] [7] [8]

Valori possibili per ogni elemento:
  "" (vuoto)
  "X" (Giocatore 1)
  "O" (Giocatore 2)
```

### Vincite Verificate

```
Combinazioni vincenti (8 totali):

Righe:
  [0, 1, 2]
  [3, 4, 5]
  [6, 7, 8]

Colonne:
  [0, 3, 6]
  [1, 4, 7]
  [2, 5, 8]

Diagonali:
  [0, 4, 8]
  [2, 4, 6]
```

### Turni

```
Sempre alternati:
  X inizia (sempre)
  → O gioca
  → X gioca
  → ...

Validazione nel server:
  if (currentPlayer != playerSymbol) {
    return error
  }
```

---

## Classi Principali

### Server: GameRoom

```dart
class GameRoom {
  Socket player1, player2
  List<String> board
  String currentPlayer
  String player1Symbol, player2Symbol
  bool gameOver
  String winner
  
  bool makeMove(int position, String symbol)
  bool checkWinner(String symbol)
  String getBoardState()
}
```

### Client: TicTacToeGame

```dart
class TicTacToeGame {
  List<String> board
  String currentPlayer
  bool gameOver
  String winner
  String? yourSymbol
  String? opponentSymbol
  
  void updateFromServer(Map<String, dynamic> state)
  bool isValidMove(int position)
  bool canMove()
  String getStatusMessage()
}
```

### Client: GameService

```dart
class GameService {
  String host, int port
  Socket _socket
  bool _isConnected
  Function(Map<String, dynamic>) onMessageReceived
  
  Future<bool> connect()
  bool get isConnected
  void joinGame()
  void makeMove(int position)
  void disconnect()
}
```

---

## Sequenza di Stati del Gioco

### Lato Client

```
CONNECTING
  ↓ (server raggiunto)
WAITING
  ↓ (secondo client connesso)
GAME_IN_PROGRESS
  ├─→ MY_TURN
  │   └─→ OPPONENT_TURN
  │
GAME_OVER
  ├─→ I_WON
  ├─→ I_LOST
  └─→ DRAW
```

### Lato Server

```
WAITING_FOR_PLAYERS
  ├─→ Player1 connected
  ├─→ WAITING_FOR_PLAYERS (1/2)
  │
GAME_IN_PROGRESS (when Player2 connects)
  ├─→ Move 1 (X)
  ├─→ Move 2 (O)
  ├─→ ...
  │
GAME_OVER
  ├─→ Player1 Won
  ├─→ Player2 Won
  └─→ Draw
```

---

## Error Handling

### Lato Client

```
try {
  socket = await Socket.connect(host, port).timeout(Duration(seconds: 10))
} catch (TimeoutException) {
  → "Timeout di connessione"
} catch (SocketException) {
  → "Errore di connessione"
} catch (FormatException) {
  → "Errore nel formato JSON"
}
```

### Lato Server

```
socket.listen(
  onData: (data) {
    try {
      Map<String, dynamic> decoded = jsonDecode(message)
      // Valida e processa
    } catch (e) {
      client.write({"type": "error", "message": ...})
    }
  },
  onError: (error) → Rimuovi client da connectedClients
  onDone: () → Cleanup e notifica avversario
)
```

---

## Scaling e Performance

### Capacità del Server

| Metrica | Valore |
|---------|--------|
| Partite simultanee | ~50-100 |
| Connessioni | 2 per partita |
| Messaggi/sec | < 100 |
| Memoria per GameRoom | ~1KB |
| Latenza | < 100ms (locale) |

### Ottimizzazioni Future

1. **Connection Pool** per riutilizzare socket
2. **Message Queue** per buffering messaggi
3. **Database** per persistenza e statistiche
4. **Authentication** per identificare utenti
5. **Rate Limiting** per prevenire abuse

---

## Testing

### Test Case Principali

```
1. Connessione al server
   ✓ Server avviato
   ✓ Client si connette
   
2. Joining game
   ✓ Player 1 in attesa
   ✓ Player 2 connesso → Gioco inizia
   
3. Game play
   ✓ Player 1 (X) muove
   ✓ Server aggiorna
   ✓ Player 2 (O) riceve aggiornamento
   ✓ Player 2 muove
   ✓ Ciclo continua
   
4. Win condition
   ✓ 3 in fila → Player vince
   ✓ Entrambi ricevono "gameOver: true"
   
5. Draw condition
   ✓ Griglia piena → Draw
   
6. Disconnection
   ✓ Player 1 esce → Player 2 notificato
```

### Script di Test

```bash
# Test manuale server
dart test_client.dart

# Test Flutter
flutter test

# Test UI
flutter run (su 2 dispositivi/emulatori)
```

---

## Sicurezza

### Vulnerabilità Note

```
⚠️ NO TLS/SSL encryption
⚠️ NO input validation robusto
⚠️ NO authentication
⚠️ NO rate limiting
⚠️ NO DDOS protection
```

### Raccomandazioni Produzione

```
1. Implementare SSL/TLS
2. Validare rigorosamente JSON
3. Aggiungere autenticazione
4. Rate limiting per IP
5. Timeout di connessione
6. Logging e monitoring
```

---

## Licenza

Progetto educativo per TPSIT 2025-26
