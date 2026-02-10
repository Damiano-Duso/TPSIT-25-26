# Guida Rapida per Sviluppatori

## Avvio Veloce (5 minuti)

### Passo 1: Setup iniziale
```bash
cd remote_game
flutter pub get
```

### Passo 2: Avviare il server (Terminal 1)
```bash
dart server.dart
```

Atteso: `Server avviato su porta 5000`

### Passo 3: Avviare l'app (Terminal 2)
```bash
flutter run
```

### Passo 4: Connettere il primo client
- Server: `localhost`
- Porta: `5000`
- Click: Connetti al Server

### Passo 5: Secondo client (nuovo emulatore/dispositivo)
- Ripetere passo 3 e 4

### Passo 6: Giocare!
- Player 1 è X (inizia)
- Player 2 è O
- Click sulle celle per piazzare il simbolo

---

## Struttura dei File

```
lib/
├── main.dart                    # Entry point
├── models/
│   └── game_model.dart         # TicTacToeGame class
├── services/
│   └── game_service.dart       # Comunicazione TCP
└── screens/
    ├── connection_screen.dart   # Login screen
    └── game_screen.dart         # Game board
```

---

## Modificare il Gioco

### Cambiare la porta del server

**File: server.dart (linea ~15)**
```dart
final port = 5000;  // Cambia questo numero
```

### Aggiungere un messaggio personalizzato

**File: lib/screens/game_screen.dart**
```dart
statusMessage = "Messaggio personalizzato";
```

### Cambiare i colori

**File: lib/screens/game_screen.dart**
```dart
backgroundColor: Colors.deepPurple,  // Cambia il colore
```

### Modificare la griglia

**File: lib/screens/game_screen.dart (linea ~130)**
```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,  // Numero di colonne
    mainAxisSpacing: 8, // Spazio verticale
    crossAxisSpacing: 8, // Spazio orizzontale
  ),
  ...
)
```

---

## Debugging

### Aggiungere Log

**Nel server (server.dart):**
```dart
print('Mossa ricevuta: $position da ${client.remoteAddress.address}');
```

**Nel client (lib/services/game_service.dart):**
```dart
print('Messaggio dal server: $decoded');
```

### Leggere i Log

**Flutter:**
```
View → Debug Console
```

**Dart Server:**
Visibile nel terminale dove è stato avviato

---

## Testing

### Test del server manuale

```bash
dart test_client.dart
```

Questo script:
1. Si connette al server
2. Invia il comando joinGame
3. Mostra la risposta del server
4. Simula una mossa

### Test dell'app

```bash
flutter test
```

---

## Errori Comuni

### "Connection refused"
```
Soluzione: Assicurati che il server sia avviato
$ dart server.dart
```

### "Port already in use"
```
Soluzione: Cambia la porta nel server.dart oppure:

# Windows
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# Mac/Linux
lsof -ti:5000 | xargs kill -9
```

### "Cannot connect from Android Emulator"
```
Soluzione: Usa 10.0.2.2 invece di localhost
Server: 10.0.2.2
Porta: 5000
```

---

## Aggiungere una Nuova Funzionalità

### Esempio: Aggiungere uno score tracker

1. **Modifica game_model.dart:**
```dart
class TicTacToeGame {
  int player1Wins = 0;
  int player2Wins = 0;
  
  void addWin(String player) {
    if (player == 'X') player1Wins++;
    else player2Wins++;
  }
}
```

2. **Modifica game_screen.dart:**
```dart
Text('X: ${game.player1Wins} - O: ${game.player2Wins}')
```

---

## Performance Tips

1. **Usa const quando possibile:**
```dart
const Text('Tris Online')  // Meglio
Text('Tris Online')        // Evitare
```

2. **Evita rebuild non necessari:**
```dart
Widget build(BuildContext context) {
  return const MyWidget();  // Previene rebuild
}
```

3. **Usa ListView.builder per liste lunghe:**
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => Item(items[index]),
)
```

---

## Variabili Globali Utili

Nel client Flutter:
```dart
const String DEFAULT_SERVER = 'localhost';
const int DEFAULT_PORT = 5000;
const Duration NETWORK_TIMEOUT = Duration(seconds: 10);
```

Nel server:
```dart
const int MAX_GAMES = 100;
const Duration CONNECTION_TIMEOUT = Duration(minutes: 5);
```

---

## Checkpoints

- [ ] Server si avvia senza errori
- [ ] App Flutter si lancia
- [ ] Primo client si connette (vede "In attesa...")
- [ ] Secondo client si connette (gioco inizia)
- [ ] Player 1 (X) può fare una mossa
- [ ] Player 2 (O) riceve l'aggiornamento
- [ ] Il gioco sa quando uno vince
- [ ] Il gioco sa quando è pareggio

---

## Resources

- [Documentazione Flutter](https://flutter.dev/docs)
- [Documentazione Dart](https://dart.dev/guides)
- [Socket TCP in Dart](https://api.dart.dev/stable/dart-io/Socket-class.html)

---

## Contatti/Note

Progetto educativo TPSIT 2025-26
