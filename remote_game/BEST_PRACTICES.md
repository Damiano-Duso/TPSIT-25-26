# Best Practices per lo Sviluppo

Questo documento descrive le best practices e gli standard di coding per il progetto Tris Online.

## Code Style

### Dart/Flutter Style

Seguire le [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style):

```dart
// ✓ Bene
class GameScreen extends StatefulWidget {
  const GameScreen({
    Key? key,
    required this.gameService,
  }) : super(key: key);

  final GameService gameService;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

// ✗ Male
class GameScreen extends StatefulWidget {
  GameScreen({required this.gameService});
  final GameService gameService;
  @override
  _GameScreenState createState() => _GameScreenState();
}
```

### Naming Conventions

```dart
// Classi: PascalCase
class GameService { }

// Variabili/proprietà: camelCase
String currentPlayer = 'X';

// Costanti: camelCase o SCREAMING_SNAKE_CASE
const int GRID_SIZE = 3;
const String defaultHost = 'localhost';

// Metodi privati: _leadingUnderscore
void _handleMessage(Map<String, dynamic> msg) { }

// File: snake_case.dart
// ✓ game_service.dart
// ✗ GameService.dart
```

### Documentazione

```dart
/// Descrizione della classe
/// 
/// Dettagli più lunghi se necessario.
/// Può contenere esempi:
/// 
/// ```dart
/// final service = GameService(host: 'localhost', port: 5000);
/// ```
class GameService {
  /// Descrizione della proprietà
  final String host;
  
  /// Descrizione del metodo
  /// 
  /// [parameter]: descrizione parametro
  /// Returns: descrizione ritorno
  Future<bool> connect() async { }
}
```

## Architettura

### Struttura delle Cartelle

```
lib/
├── config/          # Configurazioni globali
├── models/          # Modelli di dati
├── screens/         # Widget di schermata
├── services/        # Servizi (network, database, etc.)
└── widgets/         # Widget riutilizzabili (se necessario)
```

### Separazione delle Responsabilità

```dart
// ✓ Bene: Service gestisce la rete
class GameService {
  Future<bool> connect() async { }
  void makeMove(int position) { }
}

// ✓ Bene: Screen gestisce UI
class GameScreen extends StatefulWidget {
  final GameService gameService;
  @override
  _GameScreenState createState() => _GameScreenState();
}

// ✗ Male: Screen che gestisce anche rete
class GameScreen extends StatefulWidget {
  void connectAndJoinGame() {
    socket = await Socket.connect(...);  // NO!
  }
}
```

## Testing

### Unit Tests

```dart
// test/models/game_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_game/models/game_model.dart';

void main() {
  group('TicTacToeGame', () {
    late TicTacToeGame game;

    setUp(() {
      game = TicTacToeGame();
    });

    test('isValidMove returns true for empty cell', () {
      expect(game.isValidMove(0), true);
    });

    test('isValidMove returns false for occupied cell', () {
      game.board[0] = 'X';
      expect(game.isValidMove(0), false);
    });

    test('detectsWinner correctly', () {
      game.board = ['X', 'X', 'X', '', '', '', '', '', ''];
      expect(game.checkWinner('X'), true);
    });
  });
}
```

### Widget Tests

```dart
// test/screens/game_screen_test.dart
void main() {
  testWidgets('GameScreen displays grid', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: GameScreen(gameService: mockGameService),
      ),
    );

    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(GestureDetector), findsWidgets);
  });
}
```

### Integration Tests

```dart
// test_integration.dart
Future<void> testCompleteGame() async {
  ClientSimulator player1 = ClientSimulator('Player1');
  ClientSimulator player2 = ClientSimulator('Player2');

  await player1.connect('localhost', 5000);
  await player2.connect('localhost', 5000);

  player1.joinGame();
  player2.joinGame();

  // Simula una partita
}
```

## Performance

### Evitare Rebuild Non Necessari

```dart
// ✓ Bene
const MyWidget()

// ✗ Male (rebuild ad ogni parent rebuild)
MyWidget()

// ✓ Bene: Usa const dove possibile
const Text('Tris Online')

// ✗ Male
Text('Tris Online')
```

### Usare ListView.builder per Liste Lunghe

```dart
// ✓ Bene
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)

// ✗ Male per liste lunghe
ListView(
  children: items.map((item) => ItemWidget(item)).toList(),
)
```

### Evitare Callback in Build

```dart
// ✗ Male: Crea nuovo callback ad ogni build
Container(
  onTap: () => print('tapped'),
)

// ✓ Bene: Salva come variabile membro
final Function() onTap = () => print('tapped');

Container(
  onTap: onTap,
)
```

## Errori Comuni

### 1. Memory Leak con Socket

```dart
// ✗ Male
Socket socket;
socket = await Socket.connect(...);
// Non chiudi mai la socket!

// ✓ Bene
@override
void dispose() {
  socket.close();
  super.dispose();
}
```

### 2. Nested Futures

```dart
// ✗ Male: Callback Hell
socket.listen((data) {
  var msg = jsonDecode(data);
  // Nested callbacks
});

// ✓ Bene: Usa async/await
void _handleMessage(Map<String, dynamic> msg) async {
  await updateUI();
}
```

### 3. Mancanza di Error Handling

```dart
// ✗ Male
Future<bool> connect() async {
  socket = await Socket.connect(host, port);
  return true;
}

// ✓ Bene
Future<bool> connect() async {
  try {
    socket = await Socket.connect(host, port).timeout(
      Duration(seconds: 10),
    );
    return true;
  } on SocketException {
    print('Connection failed');
    return false;
  } on TimeoutException {
    print('Connection timeout');
    return false;
  }
}
```

### 4. Race Conditions

```dart
// ✗ Male: Race condition se l'utente clicca due volte rapidamente
void makeMove(int position) {
  gameService.makeMove(position);  // Potrebbe essere chiamato due volte
}

// ✓ Bene: Disabilita il bottone durante l'invio
bool isSending = false;

void makeMove(int position) {
  if (isSending) return;
  isSending = true;
  gameService.makeMove(position);
  // Resetta quando ricevi la risposta
}
```

## Logging

### Server (Dart)

```dart
// ✓ Bene: Logging strutturato
print('[${DateTime.now()}] Client connesso: ${client.remoteAddress.address}');
print('[${DateTime.now()}] Mossa: posizione $position');
print('[${DateTime.now()}] Vincitore: $symbol');

// Per debugging avanzato
if (DEBUG_MODE) {
  print('DEBUG: Board state = $board');
}
```

### Client (Flutter)

```dart
// ✓ Bene: Log nel debug console
print('GameService: Connesso a $host:$port');
print('GameService: Ricevuto ${response['type']}');

// Per debugging con timestamp
print('[${DateTime.now().toString()}] Messaggio ricevuto');
```

## Security

### Validazione Input

```dart
// ✗ Male: Nessuna validazione
void makeMove(int position) {
  gameService.makeMove(position);
}

// ✓ Bene: Validazione robusta
void makeMove(int position) {
  if (position < 0 || position >= 9) {
    print('Posizione non valida');
    return;
  }
  if (board[position].isNotEmpty) {
    print('Cella già occupata');
    return;
  }
  gameService.makeMove(position);
}
```

### Gestione Secrets

```dart
// ✗ Male: Hardcoded in codice
const String API_KEY = 'abc123xyz';

// ✓ Bene: Da variabili d'ambiente
String apiKey = Platform.environment['API_KEY'] ?? 'default';

// ✓ Bene per Flutter: Usa dotenv
import 'package:flutter_dotenv/flutter_dotenv.dart';
String apiKey = dotenv.env['API_KEY']!;
```

## Documentation

### Commenti Utili

```dart
// ✓ Bene: Spiega il PERCHÈ
// Usiamo 10 secondi di timeout perché WiFi lento potrebbe richiedere più tempo
final socket = await Socket.connect(host, port).timeout(
  Duration(seconds: 10),
);

// ✗ Male: Spiega ovviamente cosa fa
// Incrementa il contatore
count++;
```

### README

Ogni funzione complessa dovrebbe avere un README:

```markdown
# GameService

Gestisce la comunicazione TCP con il server.

## Uso

```dart
final service = GameService(host: 'localhost', port: 5000);
await service.connect();
service.joinGame();
service.makeMove(4);
```

## API

- `connect()`: Connettiti al server
- `joinGame()`: Entra in una partita
- `makeMove(int position)`: Effettua una mossa
```

## Version Control

### Commit Messages

```
✓ Bene:
"feat: Aggiungi validazione mosse nel client"
"fix: Correggi race condition in GameService"
"refactor: Estrai logica validazione in metodo separato"
"docs: Aggiorna PROTOCOLLO.md"

✗ Male:
"update"
"fixed"
"changes"
"asdf"
```

### Branching Strategy

```
main          # Codice stabile
├── develop   # Integrazione features
│   ├── feature/tris-game
│   ├── feature/websocket-support
│   └── bugfix/socket-leak
```

## Refactoring Checklist

Prima di pushare il codice:

- [ ] Codice compila senza warning
- [ ] Tutti i test passano
- [ ] Niente codice duplicato
- [ ] Niente variabili inutilizzate
- [ ] Niente commenti inutili
- [ ] Niente TODO/FIXME rimasti
- [ ] Documentazione aggiornata
- [ ] Commit message chiaro
- [ ] Formato codice (dart format)
- [ ] Lint run (flutter analyze)

## Tools

### Dart Format

```bash
# Formatta un file
dart format lib/screens/game_screen.dart

# Formatta ricorsivamente
dart format lib/
```

### Lint

```bash
# Analizza il codice
flutter analyze

# Usa regole strict
flutter analyze --no-congratulate
```

### Testing

```bash
# Test singolo file
flutter test test/models/game_model_test.dart

# Tutti i test
flutter test

# Con coverage
flutter test --coverage
```

## Resources

- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Best Practices](https://flutter.dev/docs/testing)
- [Google Dart Style Guide](https://google.github.io/styleguide/dartguide.html)
- [Clean Code Principles](https://clean-code-java.readthedocs.io/)

## Conclusione

Seguire queste best practices rende il codice:
- ✓ Più leggibile
- ✓ Più mantenibile
- ✓ Più testabile
- ✓ Più sicuro
- ✓ Più performante

Per qualsiasi domanda, consulta il team di sviluppo.
