# Tris Online - File Map

Mappa completa di tutti i file del progetto con descrizioni.

## 📁 Struttura Completa

```
remote_game/
│
├── 📄 DOCUMENTAZIONE (Leggi PRIMA)
│   ├── ⭐ INSTALLAZIONE.md         Setup iniziale (LEGGI PRIMA)
│   ├── ⭐ QUICKSTART.md            Guida rapida 5 minuti (LEGGI SECONDO)
│   ├── ⭐ README.md                Documentazione principale
│   ├── INDICE.md                  Indice della documentazione
│   ├── RIEPILOGO.md               Sommario completo
│   │
│   ├── 🏗️ TECNICA
│   ├── ARCHITETTURA.md            Dettagli tecnici e design
│   ├── PROTOCOLLO.md              Specifica TCP/JSON
│   ├── DEPLOYMENT.md              Setup production e rete
│   │
│   └── 📋 SVILUPPO
│       ├── TODO.md                Roadmap e known issues
│       └── BEST_PRACTICES.md      Standard coding
│
├── 🖥️ SERVER
│   ├── server.dart                Server TCP principale (MAIN)
│   ├── run_server.sh              Script avvio Linux/Mac
│   └── run_server.bat             Script avvio Windows
│
├── 🧪 TEST & DEBUG
│   ├── test_client.dart           Test client Dart singolo
│   └── test_integration.dart      Test integrazione completa
│
├── 📱 FLUTTER APP (lib/)
│   ├── main.dart                  Entry point principale
│   │
│   ├── config/
│   │   └── constants.dart         Costanti globali
│   │
│   ├── models/
│   │   └── game_model.dart        Modello TicTacToeGame
│   │
│   ├── services/
│   │   └── game_service.dart      Servizio comunicazione TCP
│   │
│   ├── screens/
│   │   ├── connection_screen.dart Schermata di connessione
│   │   └── game_screen.dart       Schermata di gioco (MAIN UI)
│   │
│   └── [widget_test.dart]         Test (template)
│
├── 📦 CONFIGURAZIONE
│   ├── pubspec.yaml               Dipendenze Flutter (EDITARE)
│   ├── pubspec.lock               Lock file (auto-generated)
│   ├── analysis_options.yaml      Lint rules
│   └── remote_game.iml            IntelliJ config
│
├── 📱 PLATFORM NATIVE
│   ├── android/                   Codice Android nativo
│   ├── ios/                       Codice iOS nativo
│   ├── windows/                   Codice Windows nativo
│   ├── linux/                     Codice Linux nativo
│   ├── macos/                     Codice macOS nativo
│   └── web/                       Codice Web (Flutter Web)
│
├── 📂 BUILD & CACHE
│   ├── .dart_tool/                Cache Dart
│   ├── .metadata                  Metadata Flutter
│   ├── test/                      Test Flutter
│   └── build/                     Output build
│
├── ⚙️ GIT & VSCODE
│   ├── .gitignore                 Ignored files
│   ├── .idea/                     IntelliJ config
│   └── [.vscode/settings.json]    VS Code settings (opzionale)
│
└── 📄 QUESTO FILE
    └── FILE_MAP.md                (Sei qui!)
```

---

## 📄 Descrizione Dettagliata dei File

### 🔴 MUST READ (Lettura Obbligatoria)

#### INSTALLAZIONE.md
- **Tipo**: Documentazione
- **Uso**: Setup iniziale del progetto
- **Contiene**: 
  - Checklist pre-requisiti
  - Step-by-step di installazione
  - Avvio server e client
  - Troubleshooting rapido
- **Quando leggerlo**: PRIMA di tutto
- **Tempo**: 5-10 minuti

#### QUICKSTART.md
- **Tipo**: Documentazione
- **Uso**: Guida rapida per iniziare
- **Contiene**:
  - Avvio in 5 minuti
  - Comandi frecvent
  - Errori comuni
  - Modifiche base
- **Quando leggerlo**: SECONDO, dopo INSTALLAZIONE.md
- **Tempo**: 5 minuti

#### README.md
- **Tipo**: Documentazione
- **Uso**: Documentazione principale
- **Contiene**:
  - Panoramica progetto
  - Come giocare
  - Griglia di gioco
  - Protocollo (summary)
- **Quando leggerlo**: TERZO, poi ogni tanto
- **Tempo**: 10-15 minuti

---

### 🟢 CORE CODE (Codice Principale)

#### server.dart
- **Tipo**: Codice Server
- **Linguaggio**: Dart
- **Uso**: Server TCP che gestisce il gioco
- **Contiene**:
  - Classe GameRoom
  - Logica Tris
  - Validazione mosse
  - Rilevamento vincita
  - Gestione connessioni
- **Da avviare con**: `dart server.dart`
- **Porta**: 5000 (modificabile)
- **Modificare**: linea 15 per porta diversa

#### lib/main.dart
- **Tipo**: Codice App
- **Linguaggio**: Dart/Flutter
- **Uso**: Entry point dell'app Flutter
- **Contiene**:
  - Classe MyApp
  - Theme configuration
  - Route a ConnectionScreen
- **Da avviare con**: `flutter run`
- **Modificare**: ThemeData per cambiare colori

#### lib/screens/connection_screen.dart
- **Tipo**: Widget Flutter
- **Uso**: Schermata di connessione
- **Contiene**:
  - TextFields per IP/Porta
  - Pulsante "Connetti al Server"
  - Istruzioni gioco
  - Form validation
- **UI**: Material Design

#### lib/screens/game_screen.dart
- **Tipo**: Widget Flutter
- **Uso**: Schermata di gioco (MAIN UI)
- **Contiene**:
  - GridView 3x3 interattiva
  - Visualizzazione turno
  - Messaggi di stato
  - Gestione mosse
  - Rilevamento fine partita
- **Interattività**: Click su celle per giocare

#### lib/services/game_service.dart
- **Tipo**: Servizio
- **Linguaggio**: Dart
- **Uso**: Comunicazione TCP con server
- **Contiene**:
  - Connessione socket
  - Invio mosse (JSON)
  - Ricezione messaggi
  - Error handling
- **Callback**: onMessageReceived

#### lib/models/game_model.dart
- **Tipo**: Model
- **Uso**: Stato del gioco locale
- **Contiene**:
  - Classe TicTacToeGame
  - Board state
  - Validazione locale
  - Messaggi di stato
- **Dato**: Non contiene logica server, solo state

#### lib/config/constants.dart
- **Tipo**: Configurazione
- **Uso**: Costanti globali
- **Contiene**:
  - SERVER_PORT, SERVER_HOST
  - CLIENT timeouts
  - Colori, spacing
  - Messaggi
  - Feature flags
- **Modificare**: Per config globale

---

### 🟡 TESTING & HELPER (Test e Utilità)

#### test_client.dart
- **Tipo**: Codice Test
- **Linguaggio**: Dart
- **Uso**: Test client TCP singolo
- **Da avviare con**: `dart test_client.dart`
- **Contiene**:
  - Connessione test
  - Invio joinGame
  - Verifica risposta
  - Simulazione mossa
- **Output**: Test report con ✓ e ✗

#### test_integration.dart
- **Tipo**: Codice Test
- **Linguaggio**: Dart
- **Uso**: Test completo di integrazione
- **Da avviare con**: `dart test_integration.dart`
- **Contiene**:
  - Classe ClientSimulator
  - Due client che giocano
  - Sequenza mosse
  - Rilevamento vincita
- **Output**: Stampa il board durante il gioco

#### run_server.sh
- **Tipo**: Script Shell
- **Uso**: Avviare server su Linux/Mac
- **Da avviare con**: `./run_server.sh` o `bash run_server.sh`
- **Contiene**: Comando `dart server.dart`

#### run_server.bat
- **Tipo**: Script Batch
- **Uso**: Avviare server su Windows
- **Da avviare con**: `run_server.bat` (doppio click o `.\run_server.bat`)
- **Contiene**: Comando `dart server.dart` con pause finale

---

### 🟣 CONFIGURATION (Configurazione)

#### pubspec.yaml
- **Tipo**: Configurazione Flutter
- **Uso**: Dipendenze e metadata del progetto
- **Contiene**:
  - Nome app: "remote_game"
  - Versione: "1.0.0+1"
  - SDK requirement: "^3.10.4"
  - Dipendenze Flutter
  - Material design flag
- **Modificare**: Per aggiungere dipendenze
- **Generato da**: flutter pub get → pubspec.lock

#### pubspec.lock
- **Tipo**: Lock file
- **Generato**: Automaticamente
- **Uso**: Fissa le versioni dipendenze
- **NON MODIFICARE**: Usa `flutter pub get` per aggiornare

#### analysis_options.yaml
- **Tipo**: Configurazione Lint
- **Uso**: Regole di analisi Dart
- **Contiene**: Lint rules enabled
- **Modificare**: Se vuoi regole diverse

#### remote_game.iml
- **Tipo**: Configurazione IntelliJ
- **Uso**: Riconoscimento progetto in Android Studio
- **NON MODIFICARE**: Generato automaticamente

---

### 📚 DOCUMENTATION (Documentazione)

#### INDICE.md
- **Uso**: Indice di tutti i documenti
- **Contiene**: 
  - Link a tutti i file
  - Come leggerli
  - Quick reference
- **Leggi quando**: Cerchi documenti specifici

#### ARCHITETTURA.md
- **Tipo**: Documentazione tecnica
- **Uso**: Dettagli progettuali
- **Contiene**:
  - Diagrammi architettura
  - Flusso dati
  - Descrizione classi
  - Sequenza stati
  - Performance metrics
- **Quando**: Se vuoi capire a fondo come funziona

#### PROTOCOLLO.md
- **Tipo**: Specifica tecnica
- **Uso**: Dettagli comunicazione TCP
- **Contiene**:
  - Formato messaggi JSON
  - Client-Server flow
  - Errori possibili
  - Esempi sessione
  - Debugging tips
- **Quando**: Se sviluppi client/server alternativi

#### DEPLOYMENT.md
- **Tipo**: Documentazione operativa
- **Uso**: Setup per deployment
- **Contiene**:
  - Setup locale/rete
  - Android Emulator
  - Build per produzione
  - Docker setup
  - Monitoring
  - Security checklist
- **Quando**: Se vuoi deployare

#### TODO.md
- **Tipo**: Roadmap + Known Issues
- **Uso**: Pianificazione sviluppo
- **Contiene**:
  - Features completate ✅
  - Miglioramenti futuri 🔮
  - Known issues 🐛
  - Debug checklist
  - Come reportare issue
- **Quando**: Se vuoi aggiungere feature

#### BEST_PRACTICES.md
- **Tipo**: Standard coding
- **Uso**: Guida per scrivere buon codice
- **Contiene**:
  - Style guide Dart
  - Naming conventions
  - Testing patterns
  - Performance tips
  - Errori comuni
  - Security best practices
- **Quando**: Prima di scrivere nuoto codice

#### RIEPILOGO.md
- **Tipo**: Executive summary
- **Uso**: Panoramica completa
- **Contiene**:
  - Cosa è stato fatto ✅
  - Struttura file
  - Flusso dati
  - Quick start
  - Performance overview
  - Security notes
- **Quando**: Overview veloce

---

### 📂 PLATFORM & BUILD (Piattaforme Native)

#### android/
- **Tipo**: Cartella Android nativo
- **Contiene**: 
  - Gradle configuration
  - Android manifest
  - Native plugins
  - Assets Android
- **Modificare**: Se aggiungi plugin native

#### ios/
- **Tipo**: Cartella iOS nativo
- **Contiene**:
  - Xcode project
  - Pod configuration
  - Native code
  - Assets iOS
- **Modificare**: Se aggiungi plugin native

#### windows/, linux/, macos/
- **Tipo**: Cartelle piattaforme desktop
- **Contiene**: Codice nativo per desktop
- **Nota**: Non necessari per mobile

#### web/
- **Tipo**: Cartella Flutter Web
- **Contiene**: Configurazione web
- **Nota**: Per deployare come web app

#### build/, .dart_tool/
- **Tipo**: Cache e output build
- **Generato**: Automaticamente
- **NON MODIFICARE**: Usa `flutter clean` se problemi

#### test/
- **Tipo**: Cartella test Flutter
- **Contiene**: widget_test.dart (template)
- **Aggiungere**: Unit test qui

---

### 🔧 UTILITY FILES

#### .gitignore
- **Tipo**: Git configuration
- **Uso**: File da ignorare in git
- **Contiene**: build/, .dart_tool/, pubspec.lock, etc.

#### .metadata
- **Tipo**: Flutter metadata
- **Generato**: Automaticamente
- **Uso**: Traccia versione Flutter

---

## 🗺️ Mappa di Navigazione

### "Voglio iniziare SUBITO"
```
1. INSTALLAZIONE.md (5 min)
2. QUICKSTART.md (5 min)
3. flutter run
```

### "Voglio capire il codice"
```
1. README.md (main overview)
2. ARCHITETTURA.md (design)
3. Leggi: server.dart → game_service.dart → game_screen.dart
4. PROTOCOLLO.md (communication spec)
```

### "Voglio aggiungere feature"
```
1. TODO.md (vedi cosa serve)
2. ARCHITETTURA.md (dove aggiungere)
3. BEST_PRACTICES.md (come scrivere)
4. Modifica files + test
5. flutter run (prova)
```

### "Voglio deployare"
```
1. DEPLOYMENT.md (scegli ambiente)
2. BEST_PRACTICES.md (security)
3. Setup server
4. Build app (flutter build apk/ios)
```

### "Mi serve aiuto"
```
1. INSTALLAZIONE.md (troubleshooting base)
2. DEPLOYMENT.md (troubleshooting rete)
3. BEST_PRACTICES.md (errori comuni)
4. TODO.md (known issues)
5. Esegui: dart test_client.dart
```

---

## 🎯 Esercizi Suggeriti

### Esercizio 1: Avvio (5 min)
- [ ] Leggi INSTALLAZIONE.md
- [ ] Leggi QUICKSTART.md
- [ ] Avvia server e 2 client
- [ ] Gioca una partita

### Esercizio 2: Capire il Codice (30 min)
- [ ] Leggi ARCHITETTURA.md
- [ ] Segui il flusso dati
- [ ] Leggi server.dart
- [ ] Leggi game_service.dart
- [ ] Leggi game_screen.dart

### Esercizio 3: Piccola Modifica (20 min)
- [ ] Modifica colore primario (main.dart)
- [ ] Modifica messaggio di vittoria (game_screen.dart)
- [ ] Modifica porta server (server.dart + constants.dart)
- [ ] flutter run (prova i cambiamenti)

### Esercizio 4: Aggiungere Feature (1-2 ore)
- [ ] Scegli feature da TODO.md
- [ ] Leggi BEST_PRACTICES.md
- [ ] Implementa
- [ ] Testa con test_integration.dart
- [ ] Documenta

---

## 📊 File Statistics

| Categoria | File | Descrizione |
|-----------|------|-------------|
| **Docs** | 10 | Documentazione |
| **Code** | 6 | Codice app |
| **Test** | 2 | Test e debug |
| **Config** | 5 | Configurazione |
| **Platform** | 6 | Codice native |
| **Total** | 29+ | Files e cartelle |

---

## ✅ Checklist Esplorazione

- [ ] Leggi INSTALLAZIONE.md
- [ ] Leggi QUICKSTART.md
- [ ] Esegui `flutter pub get`
- [ ] Esegui `dart server.dart`
- [ ] Esegui `flutter run` (2 volte)
- [ ] Gioca una partita
- [ ] Leggi README.md
- [ ] Esplora lib/screens/game_screen.dart
- [ ] Esplora lib/services/game_service.dart
- [ ] Esplora server.dart
- [ ] Leggi ARCHITETTURA.md
- [ ] Esegui `dart test_client.dart`
- [ ] Esegui `dart test_integration.dart`
- [ ] Modifica un colore e prova
- [ ] Leggi TODO.md e sceglie cosa aggiungere

---

## 🎓 Learning Path

```
Principiante
   ↓
[INSTALLAZIONE.md] → [QUICKSTART.md] → [flutter run]
   ↓
Intermedio
   ↓
[README.md] → [ARCHITETTURA.md] → Leggi codice
   ↓
Avanzato
   ↓
[PROTOCOLLO.md] → [DEPLOYMENT.md] → Implementa feature
   ↓
Expert
   ↓
[BEST_PRACTICES.md] → [TODO.md] → Contribuisci
```

---

## 🔗 Quick Links

Apri questi file mentre sviluppi:
- Server: [server.dart](server.dart) - Main server logic
- App: [main.dart](lib/main.dart) - App entry point
- Connection: [connection_screen.dart](lib/screens/connection_screen.dart) - Login UI
- Game: [game_screen.dart](lib/screens/game_screen.dart) - Game UI
- Service: [game_service.dart](lib/services/game_service.dart) - Network
- Model: [game_model.dart](lib/models/game_model.dart) - Game state
- Config: [constants.dart](lib/config/constants.dart) - Global config

---

**Progetto educativo TPSIT 2025-26**
**Versione**: 1.0.0
**Status**: Production Ready
