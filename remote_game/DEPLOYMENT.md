# Guida al Deployment e Configurazione

Questo documento fornisce istruzioni per deployare e configurare l'applicazione Tris Online su diversi ambienti.

## Configurazione Locale (Desarrollo)

### Prerequisiti
- Dart SDK 3.10.4+
- Flutter SDK (con Dart incluso)
- Android Studio o Xcode (per emulatore)

### Passi

1. **Setup del progetto:**
```bash
cd remote_game
flutter pub get
```

2. **Terminal 1 - Avviare il server:**
```bash
dart server.dart
```

Output atteso:
```
Server avviato su porta 5000
```

3. **Terminal 2 - Avviare l'emulatore:**
```bash
flutter emulators --launch <emulator_id>
```

4. **Terminal 3 - Eseguire l'app:**
```bash
flutter run
```

5. **Per il secondo giocatore:**

Aprire un altro emulatore o dispositivo e ripetere il passo 4.

### Connessione in localhost

- **Server**: `localhost`
- **Porta**: `5000`

## Deployment in Rete Locale

Utile per giocare tra dispositivi diversi sulla stessa rete WiFi.

### Configurazione

1. **Trovare l'IP della macchina server:**

**Windows:**
```cmd
ipconfig
```

Cercare l'IPv4 Address (ad es. 192.168.1.100)

**Mac/Linux:**
```bash
ifconfig
```

Cercare inet address

2. **Avviare il server:**
```bash
dart server.dart
```

3. **Sui client (app Flutter):**
- **Server**: `192.168.1.100` (o l'IP trovato)
- **Porta**: `5000`

### Firewall

Assicurarsi che la porta 5000 sia aperta nel firewall:

**Windows:**
```cmd
netsh advfirewall firewall add rule name="Tris Server" dir=in action=allow protocol=tcp localport=5000
```

**Mac:**
```bash
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate off
```

Oppure aggiungere l'eccezione manualmente nelle impostazioni.

## Android Emulator

### Connessione al server sulla macchina host

Se il server è in esecuzione su `localhost`, usare `10.0.2.2` nell'emulator:

```
Server: 10.0.2.2
Porta: 5000
```

Questo perché l'emulatore è isolato dalla macchina host.

### Connessione a server in rete

Usare l'indirizzo IP della macchina server come al solito:

```
Server: 192.168.1.100
Porta: 5000
```

## iOS Simulator

### Connessione al server sulla macchina host

iOS Simulator può raggiungere l'host su:

```
Server: 127.0.0.1 o localhost
Porta: 5000
```

## Build per Produzione

### Android

1. **Configurare il certificato di signing:**
```bash
flutter build apk --release
```

2. **Generare AAB (App Bundle):**
```bash
flutter build appbundle --release
```

3. **Output:**
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

### iOS

1. **Build per iOS:**
```bash
flutter build ios --release
```

2. **Configurare il certificato di provisioning in Xcode**

3. **Archivio per App Store:**
```bash
flutter build ipa --release
```

## Modifica della Porta

Se la porta 5000 è già in uso, è possibile cambiarla:

### Nel server (server.dart)

Cambiare la riga:
```dart
final port = 5000;
```

In:
```dart
final port = 8080;  // O un'altra porta disponibile
```

### Nell'app Flutter

La porta è inserita dall'utente nella schermata di connessione, quindi non necessita modifica.

## Logging

### Server

Il server stampa log nella console:

```
Client connesso: 127.0.0.1
Messaggio ricevuto: {"action":"joinGame"}
```

### Client Flutter

Aggiungere logging nel file `lib/services/game_service.dart`:

```dart
print('Connesso al server: $host:$port');
print('Messaggio ricevuto: $message');
```

## Troubleshooting di Deployment

### Il server non si avvia

**Errore**: "Error: Could not start the null kernel isolate"

**Soluzione**: Assicurarsi che Dart SDK sia correttamente installato:
```bash
dart --version
```

### La porta è occupata

**Errore**: "Address already in use"

**Windows:**
```cmd
netstat -ano | findstr :5000
taskkill /PID <PID> /F
```

**Mac/Linux:**
```bash
lsof -ti:5000 | xargs kill -9
```

### Connessione rifiutata dal client

1. Verificare che il server sia avviato
2. Controllare l'indirizzo IP inserito
3. Verificare il firewall

### App si blocca al tentativo di connessione

1. Verificare che il server sia disponibile
2. Controllare i log dell'app Flutter
3. Riprovare con timeout più lungo

## Monitoring

### Per monitorare i client connessi

Aggiungere al server:

```dart
print('Client connessi: ${connectedClients.length}');
for (var entry in connectedClients.entries) {
  print('  - ${entry.key.remoteAddress.address}');
}
```

### Per monitorare le mosse

```dart
print('Mossa: client ${client.remoteAddress.address} -> posizione $position');
print('Stato board: ${room.board}');
```

## Considerazioni di Sicurezza per Deployment

⚠️ **Questa è un'implementazione educativa, NON idonea per produzione senza:

1. **Cifratura SSL/TLS**
```dart
// Usare SecureSocket invece di Socket
final secureSocket = await SecureSocket.connect(host, port, ...);
```

2. **Autenticazione**
```json
{"action": "joinGame", "username": "player1", "password": "xxx"}
```

3. **Validazione rigorosa**
```dart
if (request['position'] is! int || request['position'] < 0 || request['position'] > 8) {
  throw FormatException('Invalid position');
}
```

4. **Rate limiting**
```dart
// Limitare messaggi per secondo
```

5. **Timeout**
```dart
final socket = await Socket.connect(host, port).timeout(Duration(seconds: 10));
```

## Gestione del Ciclo di Vita

### Arresto graceful del server

Aggiungere al server:

```dart
// Prema Ctrl+C per arresto graceful
ProcessSignal.sigint.watch().listen((_) {
  print('\nArresto del server...');
  server.close();
  exit(0);
});
```

### Cleanup della connessione

Nel client:

```dart
@override
void dispose() {
  gameService.disconnect();
  super.dispose();
}
```

## Performance

### Server

Il server può gestire molte partite simultanee (una coppia di client per partita).

Limite pratico: ~100 partite simultanee su hardware moderno.

### Client

L'app Flutter rimane responsiva anche durante la comunicazione di rete grazie alla gestione asincrona.

## Variabili d'Ambiente

Per configurazioni avanzate, considerare l'uso di variabili d'ambiente:

```bash
export GAME_SERVER_PORT=5000
export GAME_SERVER_HOST=0.0.0.0
dart server.dart
```

```dart
final port = int.parse(Platform.environment['GAME_SERVER_PORT'] ?? '5000');
```

## Docker (Opzionale)

Per deployare il server in Docker:

```dockerfile
FROM google/dart:latest

WORKDIR /app
COPY . .

RUN dart pub get

EXPOSE 5000

CMD ["dart", "server.dart"]
```

```bash
docker build -t tris-server .
docker run -p 5000:5000 tris-server
```
