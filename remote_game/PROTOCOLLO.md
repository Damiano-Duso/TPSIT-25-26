# Protocollo di Comunicazione - Tris Online

Questo documento descrive il protocollo TCP/JSON utilizzato per la comunicazione tra client Flutter e server Dart nel gioco Tris Online.

## Panoramica

- **Protocollo**: TCP Socket
- **Serializzazione**: JSON
- **Terminatore**: Newline (`\n`)
- **Porta default**: 5000
- **Carattere di encoding**: UTF-8

## Flusso generale

```
CLIENT                              SERVER
  |                                   |
  +-- CONNECT (TCP) ----------------->|
  |                                   |
  +-- {"action": "joinGame"} -------->|
  |                                   |
  |<-- {"type": "waiting", ...} -----+
  |                                   |
  | (Aspetta il secondo giocatore)    |
  |                                   |
  |<-- {"type": "gameStarted", ...} -+
  |                                   |
  +-- {"action": "makeMove", ...} --->|
  |                                   |
  |<-- {"type": "gameState", ...} ---+
  |                                   |
  | (Continua il gioco)               |
  |                                   |
  |<-- {"type": "gameState", gameOver: true}
  |                                   |
  +-- DISCONNECT --------------------->|
  |                                   |
```

## Messaggi dal Client al Server

### 1. Join Game

Il client richiede di entrare in una partita.

**Richiesta:**
```json
{
  "action": "joinGame"
}
```

**Risposta (in attesa):**
```json
{
  "type": "waiting",
  "message": "In attesa di un avversario..."
}
```

**Risposta (gioco iniziato):**
```json
{
  "type": "gameStarted",
  "yourSymbol": "X",
  "opponentSymbol": "O",
  "board": ["", "", "", "", "", "", "", "", ""],
  "currentPlayer": "X"
}
```

### 2. Make Move

Il client effettua una mossa.

**Richiesta:**
```json
{
  "action": "makeMove",
  "position": 4
}
```

Dove `position` è un numero da 0 a 8 che rappresenta una cella sulla griglia:
```
0 1 2
3 4 5
6 7 8
```

**Risposta (mossa valida):**
```json
{
  "type": "gameState",
  "board": ["X", "", "", "", "O", "", "", "", ""],
  "currentPlayer": "X",
  "gameOver": false,
  "winner": ""
}
```

**Risposta (mossa non valida):**
```json
{
  "type": "error",
  "message": "Mossa non valida"
}
```

Motivi per cui una mossa è non valida:
- La cella è già occupata
- Non è il turno del giocatore
- Il gioco è terminato
- La posizione non è valida (< 0 o > 8)

## Messaggi dal Server al Client

### 1. Waiting

Inviato quando un client si connette e non ci sono avversari disponibili.

```json
{
  "type": "waiting",
  "message": "In attesa di un avversario..."
}
```

### 2. Game Started

Inviato quando due client sono connessi e il gioco può iniziare.

```json
{
  "type": "gameStarted",
  "yourSymbol": "X" | "O",
  "opponentSymbol": "O" | "X",
  "board": ["", "", "", "", "", "", "", "", ""],
  "currentPlayer": "X"
}
```

Campi:
- `yourSymbol`: Il simbolo assegnato a questo client (X o O)
- `opponentSymbol`: Il simbolo dell'avversario
- `board`: Array di 9 elementi con lo stato della griglia
- `currentPlayer`: Il simbolo del giocatore il cui turno è in corso

### 3. Game State

Inviato dopo ogni mossa valida per aggiornare lo stato del gioco.

```json
{
  "type": "gameState",
  "board": ["X", "O", "X", "", "", "", "", "", ""],
  "currentPlayer": "O",
  "gameOver": false,
  "winner": ""
}
```

Campi:
- `board`: Lo stato aggiornato della griglia
- `currentPlayer`: Il giocatore il cui turno è ora
- `gameOver`: `true` se il gioco è terminato, `false` altrimenti
- `winner`: 
  - `"X"` o `"O"` se c'è un vincitore
  - `"Draw"` se è pareggio
  - `""` (stringa vuota) se il gioco non è terminato

### 4. Error

Inviato quando si verifica un errore.

```json
{
  "type": "error",
  "message": "Descrizione dell'errore"
}
```

Errori comuni:
- "Mossa non valida"
- "Non è il tuo turno o posizione non valida"
- "Errore nel server"

### 5. Opponent Disconnected

Inviato quando l'avversario si disconnette durante il gioco.

```json
{
  "type": "opponentDisconnected",
  "message": "L'avversario si è disconnesso"
}
```

## Stato della Griglia

La griglia è rappresentata come un array di 9 elementi:

```javascript
[
  board[0], board[1], board[2],   // Riga 0
  board[3], board[4], board[5],   // Riga 1
  board[6], board[7], board[8]    // Riga 2
]
```

Ogni elemento può essere:
- `""` (stringa vuota): cella vuota
- `"X"`: marcata da giocatore X
- `"O"`: marcata da giocatore O

### Combinazioni vincenti

Il server verifica queste 8 combinazioni:
```
Orizzontali: [0,1,2], [3,4,5], [6,7,8]
Verticali:   [0,3,6], [1,4,7], [2,5,8]
Diagonali:   [0,4,8], [2,4,6]
```

## Implementazione nel Client Flutter

Nel file `lib/services/game_service.dart`:

```dart
// Inviare una richiesta
void joinGame() {
  String request = jsonEncode({"action": "joinGame"});
  _socket.write(request + '\n');
}

void makeMove(int position) {
  String request = jsonEncode({
    "action": "makeMove",
    "position": position,
  });
  _socket.write(request + '\n');
}

// Ricevere una risposta
void listen() {
  _socket.listen((data) {
    String message = utf8.decode(data).trim();
    Map<String, dynamic> response = jsonDecode(message);
    // Elaborare la risposta
  });
}
```

## Gestione degli errori

### Connection timeout
Se il client non riesce a connettersi al server entro 10 secondi, mostra un messaggio di errore.

### Network error
Se la connessione si interrompe durante il gioco, l'app mostra un messaggio di disconnessione.

### Invalid JSON
Se il server riceve un messaggio JSON non valido, risponde con un messaggio di errore.

## Sicurezza

**Note:** Questa è un'implementazione educativa e non utilizza cifratura.

Per ambienti di produzione considerare:
- SSL/TLS per la comunicazione cifrata
- Autenticazione dei giocatori
- Validazione rigida dei dati
- Rate limiting
- Timeout di connessione

## Esempi di session completa

### Sessione vincente

```
Client 1: {"action": "joinGame"}
Server:   {"type": "waiting", "message": "In attesa di un avversario..."}

Client 2: {"action": "joinGame"}

Server:   {"type": "gameStarted", "yourSymbol": "X", "opponentSymbol": "O", "board": ["","","","","","","","",""], "currentPlayer": "X"}
Server:   {"type": "gameStarted", "yourSymbol": "O", "opponentSymbol": "X", "board": ["","","","","","","","",""], "currentPlayer": "X"}

Client 1: {"action": "makeMove", "position": 0}
Server:   {"type": "gameState", "board": ["X","","","","","","","",""], "currentPlayer": "O", "gameOver": false, "winner": ""}

Client 2: {"action": "makeMove", "position": 4}
Server:   {"type": "gameState", "board": ["X","","","","O","","","",""], "currentPlayer": "X", "gameOver": false, "winner": ""}

Client 1: {"action": "makeMove", "position": 1}
Server:   {"type": "gameState", "board": ["X","X","","","O","","","",""], "currentPlayer": "O", "gameOver": false, "winner": ""}

Client 2: {"action": "makeMove", "position": 3}
Server:   {"type": "gameState", "board": ["X","X","","O","O","","","",""], "currentPlayer": "X", "gameOver": false, "winner": ""}

Client 1: {"action": "makeMove", "position": 2}
Server:   {"type": "gameState", "board": ["X","X","X","O","O","","","",""], "currentPlayer": "O", "gameOver": true, "winner": "X"}

Client 1 vince! 🎉
```

### Sessione pareggio

```
(Simile alla sopra, ma il gioco termina quando tutte le celle sono piene con "winner": "Draw")
```

## Debugging

Per debuggare il protocollo, è possibile aggiungere logging nel server:

```dart
print('Messaggio ricevuto: $message');
print('Board state: ${room.board}');
print('Winner: ${room.winner}');
```

E nel client:

```dart
print('Risposta dal server: $decoded');
```
